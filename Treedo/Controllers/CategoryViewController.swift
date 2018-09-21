//
//  CategoryViewController.swift
//  Treedo
//
//  Created by Joseph Gockerman on 9/21/18.
//  Copyright © 2018 Joseph Gockerman. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

   
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var itemArray : [Category] = [Category]()
    
    func loadItems()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("whoops! \(error)")
        }
    }
    
    
    @IBAction func addBtnPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new category"
            textField = alertTF
        }
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
          
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.itemArray.append(newCat)
            
            
            self.saveItems()
            
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func saveItems()
    {
        do
        {
        try context.save()
        }
        catch
        {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
     
      
        
      
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = itemArray[indexPath.row].name
        return cell!
    }
   
    
    
    //MARK: - TableView Datasource Methods
    
    
    //MARK: - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desc = segue.destination as! TreedoViewController
        if let indx = tableView.indexPathForSelectedRow {
            desc.selectedCat = itemArray[indx.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    
    
    //MARK: - Data Manip Methods
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
