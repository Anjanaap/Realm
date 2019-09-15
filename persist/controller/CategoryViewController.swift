//
//  CategoryViewController.swift
//  persist
//
//  Created by Chitra Hari on 22/08/19.
//  Copyright © 2019 Chitra Hari. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
  
    
    var categories :Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
//        nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    @IBAction func btnAddWorks(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert1 = UIAlertController(title: "Add new To Dos", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Add", style: .default) { (action1) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category : newCategory)
           
            
        }
        
        alert1.addAction(action1)
        alert1.addTextField { (alertTextField) in
            textField.placeholder = "Add a new To Dos "
            textField = alertTextField
        }
        present(alert1, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func saveCategories(category : Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
   
   
    }
    
    

