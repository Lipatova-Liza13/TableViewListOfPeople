//
//  ViewController.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//
let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=0ff69c32b74d705c975bcd6fe072688a&language=en-US&page=1")!

let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
    if error != nil {
            print("The error is: \(error!)")
            return
    } else if let jsonData = data {
            do {
                let decoder = JSONDecoder()
                let event = try decoder.decode(News.self, from: jsonData)
                self.news.append(contentsOf: event.results)
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            } catch let error as NSError {
              print(error)
            }
    }
}
task.resume()
import UIKit
import os.log

class ViewController: UIViewController {
    var group = [People]()
    //MARK:Properties
    @IBOutlet weak var PeopleTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredPeople: [ People ] = []
    
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
        // 1
        searchController.searchResultsUpdater = self
        
        // This is useful if you’re using another view controller for your searchResultsController. In this instance, you’ve set the current view to show the results, so you don’t want to obscure your view.
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search"
        // 4
        navigationItem.searchController = searchController
        // 5
        isModalInPresentation = true
    }
    
   private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool{
        return searchController.isActive && !isSearchBarEmpty
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPeople.count
        }
        return group.count
    }

    
    //specifies the height (in points) that row should be
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
    //UIKit raises an assertion if you return nil
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create your cell using the table view's
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        
        var peopleForFilteredCell : People
        if isFiltering {
            cell.setPeople = filteredPeople[indexPath.row]
        }
        else{
            cell.setPeople = group[indexPath.row]
        }
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
        "page": 1,
        "results":[
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

extension ViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filtredContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filtredContentForSearchText(_ searchText: String){
        filteredPeople = group.filter({ (people : People) -> Bool in
            return people.first_name.lowercased().contains(searchText.lowercased())
        })
        
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Pay Attention!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //after filtering you should reload data on your table view
        PeopleTableView.reloadData()
    }
}
