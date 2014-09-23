//
//  FiltersCell.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/21/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class FiltersCell: UITableViewCell {
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterSwitch.on = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
