//
//  ViewController.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var group = [People]()
    //MARK:Properties
    @IBOutlet weak var PeopleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleItemsFromJSON()
        PeopleTableView.register(PeopleTableViewCell.nib(), forCellReuseIdentifier: PeopleTableViewCell.identifier)
        
        PeopleTableView.tableFooterView = UIView()
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
       
}

