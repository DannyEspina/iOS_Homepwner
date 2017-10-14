//
//  ItemStore.swift
//  Homepwner
//
//  Created by Danny Espina on 10/14/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
}
