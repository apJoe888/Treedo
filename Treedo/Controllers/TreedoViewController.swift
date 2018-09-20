//
//  ViewController.swift
//  Treedo
//
//  Created by Joseph Gockerman on 9/12/18.
//  Copyright © 2018 Joseph Gockerman. All rights reserved.
//

import UIKit

class TreedoViewController: UITableViewController {

    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray : [ToDoItem] = [ToDoItem]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        let jc1 = PropertyListDecoder()
        do {
            
            let data = try Data(contentsOf: dataFilePath!)
            itemArray = try jc1.decode([ToDoItem].self, from: data)
     
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        
        
    }

    // MARK: Tableview Datasource Methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        cell?.textLabel?.text = itemArray[indexPath.row].taskName
        cell?.accessoryType = (itemArray[indexPath.row].isComplete ? .checkmark : .none)
        return cell!
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }

    
    func saveItems()
    {
        let jc = PropertyListEncoder()
        do {
            let data = try jc.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
       
    }
    
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new item"
            textField = alertTF
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newToDo = ToDoItem()
            newToDo.taskName = textField.text!
            self.itemArray.append(newToDo)
            
          
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

