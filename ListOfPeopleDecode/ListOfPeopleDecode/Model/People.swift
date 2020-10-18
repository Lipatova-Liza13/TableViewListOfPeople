//
//  People.swift
//  ListOfPeopleDecode
//
//  Created by Teslenko Anastasiya on 26.08.2020.
//  Copyright © 2020 Liza Lipatova. All rights reserved.
//

import Foundation
import os.log

class People: NSObject, Codable, NSCoding {
    var first_name:String
    var last_name:String
    var age:String
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("group")
    
    //MARK: Types
    struct PropertyKey{
        static let first_name = "first_name"
        static let last_name = "last_name"
        static let age = "age"
    }

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
    
    //MARK: NSCoding
    //I have to realizate it for archive my data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(first_name, forKey: PropertyKey.first_name)
        aCoder.encode(last_name, forKey: PropertyKey.last_name)
        aCoder.encode(age, forKey: PropertyKey.age)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {//decode
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let firstName = aDecoder.decodeObject(forKey: PropertyKey.first_name) as? String else {
            os_log("Unable to decode the name for a first_name object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lastName = aDecoder.decodeObject(forKey: PropertyKey.last_name) as? String else {
            os_log("Unable to decode the name for a last_name object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let age = aDecoder.decodeObject(forKey: PropertyKey.age) as? String else {
            os_log("Unable to decode the name for a age object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(first_name: firstName, last_name: lastName, age: age)
    }
    
}

