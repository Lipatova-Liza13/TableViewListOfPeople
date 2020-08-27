//
//  AddPersonViewController.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 27.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import UIKit
import os.log
class AddPersonViewController: UIViewController, UITextFieldDelegate {
    var pers : People?
    //MARK:Properties
    @IBOutlet weak var ageShow: UILabel!
    
    @IBOutlet weak var newSurname: UITextField!
    
    @IBOutlet weak var newName: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newSurname.delegate = self
        newName.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func addAgeStepper(_ sender: UIStepper) {
        ageShow.text = String(Int(sender.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        newName.resignFirstResponder()
        newSurname.resignFirstResponder()

        return true

    }
    //MARK: Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = newName.text ?? ""
        let surname = newSurname.text ?? ""
        let age = ageShow.text ?? "0"
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        pers = People(first_name: name, last_name: surname, age: age)
    }
}
