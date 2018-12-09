//
//  ViewController.swift
//  ContactList
//
//  Created by ASHLEY TRAN on 11/17/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UISearchDisplayDelegate, UISearchBarDelegate {
    var tableData: [Contacts] = []
    var filteredData: [Contacts] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // obtain context container //
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // share app delegate //
    let delegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    
    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditContactSegue", sender: addContactButton)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = getContacts()
        tableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContactSegue"{
            // set navigation controller as segue destination
            let navigationController = segue.destination as! UINavigationController
            
            // set add item controller to delegate
            let AddContactViewController = navigationController.topViewController as! AddContactViewController
            AddContactViewController.delegate = self as AddContactDelegate
            
            
            // edit item and pass the following parameters to additemview controller
            if let indexPath = sender as? NSIndexPath{
                let contact = tableData[indexPath.row]
                AddContactViewController.indexPath = indexPath
                AddContactViewController.titlename = "Edit Contact"
                AddContactViewController.firstname = contact.firstname
                AddContactViewController.lastname = contact.lastname
                AddContactViewController.number = contact.number
            
            }
        }

        if segue.identifier == "displayContactSegue"{
            let navigationController = segue.destination as! UINavigationController
            let DisplayContactViewController = navigationController.topViewController as! DisplayContactViewController
            DisplayContactViewController.delegate = self
            
            if let indexPath = sender as? NSIndexPath{
                let contact = tableData[indexPath.row]
                DisplayContactViewController.titlename = contact.firstname
                DisplayContactViewController.name = "\(contact.firstname!) \(contact.lastname!)"
                DisplayContactViewController.number = contact.number
            }
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (withIdentifier: "contactCell") as! contactCell
        let contact = tableData[indexPath.row]
        cell.nameLabel.text = "\(contact.firstname!) \(contact.lastname!)"
        cell.numberLabel.text = contact.number
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let view = UIAlertAction(title: "View", style: .default, handler: { (action) -> Void in
            print("View selected!")
            self.performSegue(withIdentifier: "displayContactSegue", sender: indexPath)
        })
        
        let edit = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            print("Edit selected!")
            self.performSegue(withIdentifier: "EditContactSegue", sender: indexPath)
        })
        
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
            print("Delete selected!")
            // select item to be deleted //
            let item = self.tableData[indexPath.row]
            
            // delete from data model //
            self.managedObjectContext.delete(item)
            
            // try to save database after deletion //
            do{
                try self.managedObjectContext.save()
                
            }catch{
                print("\(error)")
            }
            
            // get most current table data //
            self.tableData = self.getContacts()
            
            // reload table view data //
            tableView.reloadData()
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(view)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    
    func getContacts() -> [Contacts] {
        do {
            // fetch items from data model //
            let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
            
            // sort fetch items by date descending//
            let sectionsortDescriptors = NSSortDescriptor(key: "firstname", ascending:true)
            let sortDescriptors = [sectionsortDescriptors]
            itemRequest.sortDescriptors = sortDescriptors
            
            // fetch limit to 20 objects //
            itemRequest.fetchLimit = 20
            
            let results = try managedObjectContext.fetch(itemRequest)
            
            return results as! [Contacts]
        } catch{
            print(error)
        }
        return []
    }

}


extension ViewController: AddContactDelegate{
    func cancelButtonPressed(by controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func contactSaved(_ firstname: String, _ lastname: String, _ number: String, at indexPath: NSIndexPath?, sender: UIViewController) {
        let ip = indexPath
        let contact = tableData[(ip?.row)!]
        contact.firstname = firstname
        contact.lastname = lastname
        contact.number = number

        delegate.saveContext()
        tableData = getContacts()
        tableView.reloadData()
        sender.dismiss(animated:true, completion:nil)
    }
    
    func addContact(_ firstname: String, _ lastname: String, _ number: String, sender: UIViewController) {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: managedObjectContext) as! Contacts
        contact.firstname = firstname
        contact.lastname = lastname
        contact.number = number
        
        
        tableData.append(contact)
        delegate.saveContext()
        tableData = getContacts()
        tableView.reloadData()
        sender.dismiss(animated: true, completion: nil)
        
    }
    
}



