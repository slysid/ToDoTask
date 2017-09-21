//
//  DataModel.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation
import UIKit

enum Tags:String {
    
    case entertainment = "entertainment"
    case general
}

enum ControllerMode:String {
    
    case view
    case edit
    case add
}

enum TableMode:String {
    
    case documents
    case trash
}

struct Item:Equatable {
    
    var id:Int = 0
    var name:String = ""
    var description:String = ""
    var creationdate:String = ""
    var completed:Bool = false
    var completiondate:String = ""
    var tags:[Tags.RawValue] = []
    var trashed:Bool = false
    
    init(dictionary:[String:Any]) {
        
        self.id = dictionary["id"] as! Int
        self.name = dictionary["name"] as! String
        self.description = dictionary["description"] as! String
        self.creationdate = dictionary["creationdate"] as! String
        self.completed = dictionary["completed"] as! Bool
        self.completiondate = dictionary["completiondate"] as! String
        self.tags = dictionary["tags"] as! [Tags.RawValue]
        self.trashed = dictionary["trashed"] as! Bool
        
    }
    
    init() {
        
    }
    
    static func unpack(data:Item) -> [String:Any] {
        
        var returnData:[String:Any] = [:]
        
        returnData["id"] = data.id
        returnData["name"] = data.name
        returnData["description"] = data.description
        returnData["creationdate"] = data.creationdate
        returnData["completed"] = data.completed
        returnData["completiondate"] = data.completiondate
        returnData["tags"] = data.tags
        returnData["trashed"] = data.trashed
        
        return returnData
    }
}
