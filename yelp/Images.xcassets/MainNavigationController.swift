//
//  MainNavigationController.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/18/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = uicolorFromHex(0xd72216)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
