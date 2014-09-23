//
//  MainViewController.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/18/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var restaurants:[NSDictionary] = []
    var filteredRestaurants:[NSDictionary] = []
    var isFiltered:Bool = false
    
    let yelpConsumerKey:String = "Yt6NaO4IHxHT5CpAIIpRwQ"
    let yelpConsumerSecret:String = "vvLHJQITEDQhVmN_H1pQxm71om8"
    let yelpToken:String = "6Vk2nujxWjCrBPImkzVSyq09puJ8Vykt"
    let yelpTokenSecret:String = "zKPgXo5o3mONKjceIZIq1GJ_-s8"
    let yelpClient:YelpClient?
    let searchBar:UISearchBar = UISearchBar()
    var searchTerm:String!
    
    var filters:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        let filterButton:UIBarButtonItem = UIBarButtonItem()
        filterButton.title = "Filter"
        filterButton.style = UIBarButtonItemStyle.Bordered
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = Selector("filterAction:")
        
        searchBar.frame = CGRectMake(90, 0, 250, 44)
        searchBar.delegate = self
        searchBar.tintColor = UIColor.grayColor()
    
        self.navigationController?.navigationBar.addSubview(searchBar)
        
        self.loadRestaurantsAndShowProgressHUD()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "filtersReceived:", name: "filters", object: nil)
    }
    
    func filtersReceived(notification:NSNotification) {
        println(notification.object)
        self.filters = notification.object
        self.loadRestaurantsAndShowProgressHUD()
    }
    
    func filterAction(sender:AnyObject) {
        let filtersVC = FiltersViewController(nibName: "FiltersViewController", bundle: nil)
        self.searchBar.hidden = true
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        self.filterContentForSearchText(searchText)
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchTerm = searchBar.text
        self.loadRestaurantsAndShowProgressHUD()
        searchBar.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText (searchText: String) {
        if(searchText.utf16Count == 0) {
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("dismissKeyboard"), userInfo: nil, repeats: false)
            isFiltered = false
        } else {
            isFiltered = true
            filteredRestaurants = restaurants.filter{
                ($0["name"] as NSString).localizedCaseInsensitiveContainsString("\(searchText)")
            }
        }
        self.tableView.reloadData()
    }
    
    func getRestaurantsAndLoadTableView() -> Void {
        var client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        if(self.searchTerm == nil) {
            self.searchTerm = "San Francisco"
        }
        if((self.filters) == nil) {
            client.searchWithTerm(self.searchTerm,
                success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                    self.restaurants = response["businesses"] as [NSDictionary]
                    self.tableView.reloadData()
                    self.searchTerm = nil
                },
                failure: {(operation:AFHTTPRequestOperation!, failure:NSError!) -> Void in
            })
        } else {
            client.search(self.filters as? NSDictionary,
                success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in

                    self.restaurants = response["businesses"] as [NSDictionary]
                    self.tableView.reloadData()
                },
                failure: {(operation:AFHTTPRequestOperation!, failure:NSError!) -> Void in
            })
        }
    }
    
    func loadRestaurantsAndShowProgressHUD() -> Void {
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading Restaurants"
        hud.labelColor = UIColor.blackColor()
        dispatch.async.bg {
            self.getRestaurantsAndLoadTableView()
            dispatch.async.main {
                hud.hide(true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltered) {
            return self.filteredRestaurants.count
        } else {
            return self.restaurants.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var restaurant = NSDictionary()
        if(isFiltered) {
            restaurant = self.filteredRestaurants[indexPath.row]
        } else {
            restaurant = self.restaurants[indexPath.row]
        }
        var cell:RestaurantCell = self.tableView.dequeueReusableCellWithIdentifier("RestaurantCell") as RestaurantCell
        let location = restaurant["location"] as NSDictionary
        let address = location["address"] as? NSArray
        let categories = restaurant["categories"] as? NSArray
        var category = categories?.firstObject as? NSArray
        
        if(restaurant["is_closed"] as Int == 1) {
            cell.closedLabel.hidden = false
        }
        let reviewCount:Int = restaurant["review_count"] as Int!
        cell.userInteractionEnabled = false;
        cell.nameLabel.text = restaurant["name"] as? String
        cell.addressLabel.text = address?.firstObject as AnyObject? as? String
        cell.categoriesLabel.text = category?.componentsJoinedByString(", ")
        cell.ratingsLabel.text = String(reviewCount) + " Reviews"
        cell.layoutMargins = UIEdgeInsetsZero
        cell.nameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.nameLabel.numberOfLines = 0
//        cell.nameLabel.preferredMaxLayoutWidth = cell.nameLabel.bounds.size.width

        cell.restaurantImageView.setImageWithURL(NSURL(string:restaurant["image_url"] as String))
        cell.ratingsImageView.setImageWithURL(NSURL(string:restaurant["rating_img_url_large"] as String))
        return cell
    }
    
    func setRestaurantImageForCellImageView(cell:RestaurantCell, indexPath:NSIndexPath) -> Void {
        let restaurant = self.restaurants[indexPath.row]
        let imageUrl = restaurant["image_url"] as String
        var err: NSError?
        let placeHolderImageData:NSData = NSData.dataWithContentsOfURL(NSURL(string:imageUrl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        let placeHolderImage:UIImage = UIImage(data: placeHolderImageData)
        cell.restaurantImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string:imageUrl)), placeholderImage: placeHolderImage,
            success: {(request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                UIView.transitionWithView(cell.restaurantImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
                    cell.restaurantImageView.setImageWithURL(NSURL(string: imageUrl))
                    }, completion: nil)
            }, failure: {
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
        })
    }
    
    func setRatingsImageForCellRatingsImageView(cell:RestaurantCell, indexPath:NSIndexPath) -> Void {
        let restaurant = self.restaurants[indexPath.row]
        let imageUrl = restaurant["rating_img_url_large"] as String
        var err: NSError?
        let placeHolderImageData:NSData = NSData.dataWithContentsOfURL(NSURL(string:imageUrl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        let placeHolderImage:UIImage = UIImage(data: placeHolderImageData)
        cell.ratingsImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string:imageUrl)), placeholderImage: placeHolderImage,
            success: {(request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                UIView.transitionWithView(cell.ratingsImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
                    cell.ratingsImageView.setImageWithURL(NSURL(string: imageUrl))
                    }, completion: nil)
            }, failure: {
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchBar.hidden = false
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}