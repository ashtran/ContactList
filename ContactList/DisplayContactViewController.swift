//
//  DisplayContactViewController.swift
//  ContactList
//
//  Created by ASHLEY TRAN on 11/17/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit

class DisplayContactViewController: UIViewController {
    
    weak var delegate: AddContactDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    var titlename : String?
    var name : String?
    var number: String?

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
         delegate?.cancelButtonPressed(by: self)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.title = titlename
        nameLabel.text = name
        numberLabel.text = number
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
