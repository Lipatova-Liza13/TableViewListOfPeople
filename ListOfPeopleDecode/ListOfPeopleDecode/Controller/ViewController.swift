//
//  ViewController.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import UIKit
import os.log

 class ViewController: UIViewController {
    var group = [People]()
    //MARK:Properties
    @IBOutlet weak var PeopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PeopleTableView.register(PeopleTableViewCell.nib(), forCellReuseIdentifier: PeopleTableViewCell.identifier)
        
        PeopleTableView.tableFooterView = UIView()
        
        // Use the edit button item provided by the table view controller.
        //hhelp us to edit view
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedPeople = loadPeople() {
            group += savedPeople
        }
        else {
            // Load the sample data.
            loadSampleItemsFromJSON()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count
    }

    
    //specifies the height (in points) that row should be
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    //UIKit raises an assertion if you return nil
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create your cell using the table view's
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        cell.setPeople = group[indexPath.row]
        return cell
    }
    /*
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            group.remove(at: indexPath.row)
            savePeople()//save changes at global base
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

    }*/
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in

                self.group.remove(at: indexPath.row)
                self.savePeople()//save changes at global base
                tableView.deleteRows(at: [indexPath], with: .fade);                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if self.isEditing{
            return true
        }
        else {
            return false
        }
    }
    
    private func savePeople() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(group, toFile: People.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("People successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save people...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSampleItemsFromJSON() {
        
        let jsonString = """
            [
                {
                    "first_name": "Arthur",
                    "last_name": "Dent",
                    "age": "23"
                }, {
                    "first_name": "Zaphod",
                    "last_name": "Jolie",
                    "age": "13"
                }, {
                    "first_name": "Marvin",
                    "last_name": "Timberlake",
                    "age": "45"
                }, {
                    "first_name": "Brad",
                    "last_name": "Pitt",
                    "age": "42"
                }
            ]
        """
        let jasonData = jsonString.data(using: .utf8)!
        let usersInfo = try! JSONDecoder().decode([People].self, from: jasonData)
        
        for user in usersInfo {
            guard let person = People(first_name: user.first_name, last_name: user.last_name, age: user.age) else {
                fatalError("Unable to instantiate item1")
            }
            group += [person]
            print(user.first_name)
        }
    }
    
    
    private func loadPeople() -> [People]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: People.ArchiveURL.path) as? [People]
    }
    
    
       @IBAction func unwindToShopList(sender: UIStoryboardSegue) {
        
           if let sourceViewController = sender.source as? AddPersonViewController, let person = sourceViewController.pers {
               // Add
               let newIndexPath = IndexPath(row: group.count, section: 0)
            group.append(person)
            // Save the meals.
            savePeople()
              PeopleTableView.insertRows(at: [newIndexPath], with: .automatic)//animation
           }
       }
}

