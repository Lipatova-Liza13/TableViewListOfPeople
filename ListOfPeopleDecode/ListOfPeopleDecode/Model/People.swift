//
//  People.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import Foundation

class People: Codable {
    var first_name:String
    var last_name:String
    var age:String

init?(first_name: String, last_name: String, age: String) {
    
    // The name must not be empty
    guard !first_name.isEmpty else {
        return nil
    }
    guard !last_name.isEmpty else {
        return nil
    }
    guard !age.isEmpty else {
        return nil
    }
    self.first_name = first_name
    self.last_name = last_name
    self.age = age

    }
}
