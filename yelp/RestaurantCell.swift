//
//  RestaurantCell.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/18/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.size.height/2
        restaurantImageView.layer.masksToBounds = true;
        restaurantImageView.layer.borderWidth = 0;
        self.nameLabel.font = UIFont.boldSystemFontOfSize(17)
        self.addressLabel.font = UIFont.systemFontOfSize(12)
        self.closedLabel.hidden = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
