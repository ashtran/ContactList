//
//  AddContactDelegate.swift
//  ContactList
//
//  Created by ASHLEY TRAN on 11/17/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit

protocol AddContactDelegate: class {
    func addContact(_ firstname: String, _ lastname: String, _ number: String, sender: UIViewController)
    
    func contactSaved (_ firstname: String,_ lastname: String, _ number: String, at indexPath: NSIndexPath?, sender: UIViewController)
    
    func cancelButtonPressed (by controller: UIViewController)
}
