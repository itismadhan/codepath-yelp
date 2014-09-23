//
//  FiltersViewController.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/21/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let sectionTitles = ["Sort By", "Distance", "General", "Category"]
    let sortByOptions = ["Best Matched", "Distance", "Highest rated"]
    var sortByExpanded:Bool = false
    let distanceOptions = [[0,"Automatic"], [0.3,"0.3 miles"], [1.0,"1 mile"], [5.0,"5 miles"], [20.0,"20 miles"]]
    var distanceExpanded:Bool = false
    let toggleOptions = [["deals_filter", "Offering a Deal"]]
    var sortBySelectedIndex:Int = 0
    var selectedDistanceIndex:Int = 0
    let numberOfCategoriesCollapsed:Int = 5
    var filters:Dictionary<String, AnyObject> = [String:AnyObject]()
    var categories = YelpCategories()
    var categoriesExpanded:Bool = false
    var selectedCategories = [String]()
    
    enum Filters: Int {
       case SortBySection
       case DistanceSection
       case GeneralSection
       case CategorySection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.registerNib(UINib(nibName: "FiltersCell", bundle: nil), forCellReuseIdentifier: "FiltersCell")
        
        let expandableCellNib:UINib = UINib(nibName: "ExpandableCell", bundle: nil)
        self.tableView.registerNib(expandableCellNib, forCellReuseIdentifier: "ExpandableCell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "AllCategoriesCell")
        
        let searchButton:UIBarButtonItem = UIBarButtonItem()
        searchButton.title = "Search"
        searchButton.style = UIBarButtonItemStyle.Bordered
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = Selector("searchAction:")
        
        let cancelButton:UIBarButtonItem = UIBarButtonItem()
        cancelButton.title = "Cancel"
        cancelButton.style = UIBarButtonItemStyle.Bordered
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = Selector("cancelAction:")
    }
    
    func searchAction(sender:UIBarButtonItem) {
        self.filters["location"] = "San Francisco"
        if(!self.categories.selectedCategories.isEmpty) {
            self.filters = [String:AnyObject]()
            self.filters["location"] = "San Francisco"
            self.filters["category_filter"] = self.categories.selectedCategories.combine(",")
            self.filters["term"] = "food"
        }

        NSNotificationCenter.defaultCenter().postNotificationName("filters", object: self.filters)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelAction(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
            
        case Filters.SortBySection.toRaw():
            self.sortByExpanded = !self.sortByExpanded
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            if (self.sortByExpanded) {
                var changedIndexPaths = self.changedIndexPathsForSection(indexPath.section, startingRow: 0, endingRow: self.sortByOptions.count, excludingRow: self.sortBySelectedIndex)
                self.tableView.insertRowsAtIndexPaths(changedIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                self.sortBySelectedIndex = indexPath.row;
                self.filters["sort"] = NSNumber.numberWithInteger(indexPath.row)
                var changedIndexPaths = self.changedIndexPathsForSection(indexPath.section, startingRow: 0, endingRow: self.sortByOptions.count, excludingRow: indexPath.row)
                self.tableView.deleteRowsAtIndexPaths(changedIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            self.tableView.endUpdates()
            break;
            
        case Filters.DistanceSection.toRaw():
            self.distanceExpanded = !self.distanceExpanded
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if (self.distanceExpanded) {
                var changedIndexPaths = self.changedIndexPathsForSection(indexPath.section, startingRow: 0, endingRow: self.distanceOptions.count, excludingRow: self.selectedDistanceIndex)
                self.tableView.insertRowsAtIndexPaths(changedIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                self.selectedDistanceIndex = indexPath.row;
                self.filters.removeValueForKey("radius_filter")
                if (indexPath.row >= 1) {
                    self.filters["radius_filter"] = self.distanceOptions[indexPath.row][0]
                }
                var changedIndexPaths = self.changedIndexPathsForSection(indexPath.section, startingRow: 0, endingRow: self.distanceOptions.count, excludingRow: indexPath.row)
                self.tableView.deleteRowsAtIndexPaths(changedIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            self.tableView.endUpdates()
            break;
            
        case Filters.CategorySection.toRaw():
            if(!self.categoriesExpanded && indexPath.row == self.numberOfCategoriesCollapsed) {
                self.categoriesExpanded = !self.categoriesExpanded
            } else {
                if(self.categories.isCategorySelectedAt(indexPath.row)) {
                    self.categories.selectCategoryAt(indexPath.row, selected: false)
                } else {
                    self.categories.selectCategoryAt(indexPath.row, selected: true)
                }
            }
            self.tableView.reloadData()
            break;
            
        default:
            break;
        }
    }
    
    func changedIndexPathsForSection(section:Int, startingRow:Int, endingRow:Int, excludingRow:Int) -> [NSIndexPath] {
        var ret = [NSIndexPath]();
        for(var row:Int = startingRow; row < endingRow; ++row){
            if(row != excludingRow) {
                var path:NSIndexPath = NSIndexPath(forRow: row, inSection: section)
                ret.append(path)
            }
        }
        return ret
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case Filters.SortBySection.toRaw():
            if (self.sortByExpanded) {
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
                cell.textLabel?.text = self.sortByOptions[indexPath.row];
                if (self.sortBySelectedIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
                return cell;
            } else {
                var cell:ExpandableCell = self.tableView.dequeueReusableCellWithIdentifier("ExpandableCell") as ExpandableCell
                cell.textLabel?.text = self.sortByOptions[self.sortBySelectedIndex]
                return cell;
            }
            
        case Filters.DistanceSection.toRaw():
            if (self.distanceExpanded) {
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
                cell.textLabel?.text = self.distanceOptions[indexPath.row][1] as? String
                if (self.selectedDistanceIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None;
                }
                return cell;
            } else {
                var cell:ExpandableCell = self.tableView.dequeueReusableCellWithIdentifier("ExpandableCell") as ExpandableCell
                cell.textLabel?.text = self.distanceOptions[self.selectedDistanceIndex][1] as? String
                return cell;
            }
            
        case Filters.GeneralSection.toRaw():
            var cell:FiltersCell = self.tableView.dequeueReusableCellWithIdentifier("FiltersCell") as FiltersCell
            cell.filterNameLabel.text = self.toggleOptions[indexPath.row][1]
            var filterKey = self.toggleOptions[indexPath.row][0]
            if ((self.filters[filterKey]) != nil) {
                cell.filterSwitch.on = true
            } else {
                cell.filterSwitch.on = false
            }
            cell.filterSwitch.tag = indexPath.row
            cell.filterSwitch.removeTarget(self, action: "didToggleFilterSwitch:", forControlEvents: UIControlEvents.ValueChanged)
            cell.filterSwitch.addTarget(self, action: "didToggleFilterSwitch:", forControlEvents: UIControlEvents.ValueChanged)
            return cell;
            
        case Filters.CategorySection.toRaw():
            if (!self.categoriesExpanded && indexPath.row == self.numberOfCategoriesCollapsed) {
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AllCategoriesCell") as UITableViewCell
                cell.textLabel?.text = "More"
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.textLabel?.textColor = UIColor.redColor()
                return cell;
            } else {
                var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
                cell.textLabel?.text = self.categories.categoryAt(indexPath.row)
                if(self.categories.isCategorySelectedAt(indexPath.row)) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                return cell;
            }
            
        default:
            break;
        }
        return self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case Filters.SortBySection.toRaw():
            return self.sortByExpanded ? self.sortByOptions.count : 1;
        case Filters.DistanceSection.toRaw():
            return self.distanceExpanded ? self.distanceOptions.count : 1
        case Filters.GeneralSection.toRaw():
            return self.toggleOptions.count
        case Filters.CategorySection.toRaw():
            return self.categoriesExpanded ? self.categories.count() : self.numberOfCategoriesCollapsed + 1;
        default:
            return 0;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func didToggleFilterSwitch(sender: UISwitch) -> Void {
        var filterKey = self.toggleOptions[sender.tag][0]
        if(sender.on) {
            self.filters[filterKey] = true
        } else {
            self.filters.removeValueForKey(filterKey)
        }
    }
}

extension Array {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}



 