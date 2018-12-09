//
//  AddItemViewController.swift
//  ContactList
//
//  Created by ASHLEY TRAN on 11/17/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    var indexPath: NSIndexPath?
    weak var delegate: AddContactDelegate?
    

    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var firstnameField: UITextField!
    
    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var numberField: UITextField!
    
    var titlename = "New Contact"
    var firstname : String?
    var lastname : String?
    var number : String?
    
    @IBAction func cancelBarBurronPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let firstname = firstnameField.text!
        let lastname = lastnameField.text!
        let number = numberField.text!
        

        if firstname != "" && lastname != "" && number != "" {
            if indexPath != nil {
                delegate?.contactSaved(firstname, lastname, number, at: indexPath, sender: self)
            }
            else{
                delegate?.addContact(firstname, lastname, number, sender: self)
            }

        }
        

    }
    
    
    
    
    override func viewDidLoad() {
        titleLabel.title = titlename
        firstnameField.text = firstname
        lastnameField.text = lastname
        numberField.text = number
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
