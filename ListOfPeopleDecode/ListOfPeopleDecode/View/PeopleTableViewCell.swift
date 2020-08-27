//
//  PeopleTableViewCell.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    //MARK:Сonnect nib file
    static let identifier = "PeopleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PeopleTableViewCell", bundle: nil)
    }
    //MARK:Properties
    @IBOutlet weak var surname: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var setPeople: People! {
        didSet {
            name.text = setPeople.first_name
            surname.text = setPeople.last_name
            age.text = setPeople.age
        }
    }

}
