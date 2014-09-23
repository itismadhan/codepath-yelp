//
//  YelpCategories.swift
//  yelp
//
//  Created by Madhan Padmanabhan on 9/22/14.
//  Copyright (c) 2014 madhan. All rights reserved.
//

import Foundation

class YelpCategories {
    let categories = [
        ["indpak","Indian"],
        ["indonesian","Indonesian"],
        ["irish","Irish"],
        ["italian","Italian"],
        ["japanese","Japanese"],
        ["korean","Korean"],
        ["kosher","Kosher"],
        ["laotian","Laotian"],
        ["latin","Latin American"],
        ["colombian","Colombian"],
        ["salvadoran","Salvadoran"],
        ["venezuelan","Venezuelan"]
    ]
    var selectedCategories = [String]()
    
    func selectCategoryAt(index:Int, selected:Bool) -> Void {
        if(selected) {
            self.selectedCategories.append(self.categories[index][0])
        } else {
            self.selectedCategories.removeObject(self.categories[index][0])
        }
    }
    
    func isCategorySelectedAt(index:Int) -> Bool {
        return contains(self.selectedCategories, self.categories[index][0])
    }
    
    func categoryAt(index:Int) -> String {
        return self.categories[index][1]
    }
    
    func count() -> Int {
        return self.categories.count
    }
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if((index) != nil) {
            self.removeAtIndex(index!)
        }
    }
}