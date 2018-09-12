//
//  ViewController.swift
//  Treedo
//
//  Created by Joseph Gockerman on 9/12/18.
//  Copyright © 2018 Joseph Gockerman. All rights reserved.
//

import UIKit

class TreedoViewController: UITableViewController {

    let itemArray = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Tableview Datasource Methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        cell?.textLabel?.text = itemArray[indexPath.row]
        return cell!
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        if(selectedCell?.accessoryType == .checkmark)
        {
            selectedCell?.accessoryType = .none
        }
        else
        {
            selectedCell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

