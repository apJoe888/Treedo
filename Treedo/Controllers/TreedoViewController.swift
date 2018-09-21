//
//  ViewController.swift
//  Treedo
//
//  Created by Joseph Gockerman on 9/12/18.
//  Copyright © 2018 Joseph Gockerman. All rights reserved.
//

import UIKit
import CoreData

class TreedoViewController: UITableViewController {

    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray : [ToDoItem] = [ToDoItem]()
   
    var selectedCat : Category? {
        didSet{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            
            let pred = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCat!.name!)
            request.predicate = pred
            
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("whoops! \(error)")
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
      //  let jc1 = PropertyListDecoder()
      //  do {
            
        //    let data = try Data(contentsOf: dataFilePath!)
          //  itemArray = try jc1.decode([ToDoItem].self, from: data)
     
      //  } catch {
        //    print("Error encoding item array, \(error)")
       // }
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
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
        
        
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }

    
    func saveItems()
    {
        //let jc = PropertyListEncoder()
        do {
           // let data = try jc.encode(itemArray)
           // try data.write(to: dataFilePath!)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            try context.save()
            
            
        } catch {
            print("Error saving context, \(error)")
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
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newToDo = ToDoItem(context: context)
            newToDo.taskName = textField.text!
            newToDo.parentCategory = self.selectedCat
            newToDo.isComplete = false
            self.itemArray.append(newToDo)
            
          
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
 
    
    
}

extension TreedoViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let req : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        let pred = NSPredicate(format: "taskName CONTAINS[cd] %@", searchBar.text!)
         let pred2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCat!.name!)
        
        let aP = NSCompoundPredicate(andPredicateWithSubpredicates: [pred, pred2])
        
        
        /*
         verstationKeyPredicate = NSPredicate(format: "conversationKey = %@", conversationKey)
         let messageKeyPredicate = NSPredicate(format: "messageKey = %@", messageKey)
         let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [converstationKeyPredicate, messageKeyPredicate])
         request.predicate = andPredicate
        */
        
        
        
        req.predicate = aP
       
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sort = NSSortDescriptor(key: "taskName", ascending: true)
        req.sortDescriptors = [sort]
        
        
        do {
        itemArray = try context.fetch(req)
        }
        catch
        {
            print("error: \(error)")
        }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.count < 1)
        {
            print("yes")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("whoops! \(error)")
            }
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        else
        {
            print("no")
        }
        
    }
  
    
}
