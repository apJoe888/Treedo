//
//  ViewController.swift
//  Treedo
//
//  Created by Joseph Gockerman on 9/12/18.
//  Copyright © 2018 Joseph Gockerman. All rights reserved.
//

import UIKit

class TreedoViewController: UITableViewController {

  
    
    let defaults = UserDefaults.standard
    
    var itemArray : [String] = [String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let joe = defaults.value(forKey: "ToDo")
        {
            itemArray = joe as! [String]
        }
      
        
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

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDo")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

