//
//  ViewController.swift
//  persist
//
//  Created by Chitra Hari on 19/08/19.
//  Copyright © 2019 Chitra Hari. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UITableViewController {

    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    
  
    var selectedCategory : Category?{
       
        didSet {
            fetchData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray? [indexPath.row]{
            cell.textLabel?.text = item.title
        
//        cell.detailTextLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = item.done ? .checkmark : .none
    } else {
    
    
    cell.textLabel?.text = "no Items Added"
    }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let item = itemArray?[indexPath.row]{
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                }catch {
                    print("Error saving data,\(error)")
                }
                tableView.reloadData()
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (indexPath.row)
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done satatus,\(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func buttonAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print(textField.text!)
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new item,\(error)")
                }
            }
            print("Array updated")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
   
    func fetchData(){
        itemArray = selectedCategory?.items.sorted(byKeyPath : "title", ascending: true)
        tableView.reloadData()
    }
   
    
}
//    mark : searchBar func
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS [cd] %@",searchBar.text!).sorted(byKeyPath: "title", ascending : true)
        tableView.reloadData()
    }
    //    mark : method to return orginal list after search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchData()
    }
}

}
