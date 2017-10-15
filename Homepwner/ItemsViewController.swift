//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Danny Espina on 10/12/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.alpha = 0.65
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemStore.allItems.count
        default:
            return 1
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < 1 {
            return 60
        } else {
            return 44   // For "No more items!"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        if indexPath.section < 1 {
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        } else {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = ""
        }
        return cell
            
    }
}
