//
//  Extensions.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation
import UIKit

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var iso8601Short: String {
        
        let date = self.iso8601
        return date.components(separatedBy: "T")[0]
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

extension Dictionary {
    
    func item() -> Item {
        return Item.init(dictionary: self as! [String : Any])
    }
}

extension Array {
    
    static func itemize(data:[[String:Any]]) -> [Item] {
        
        var returnData:[Item] = []
        for d in data {
            
            let item = Item(dictionary: d)
            returnData.append(item)
        }
        return returnData
    }
}


func ==(lhs:Item,rhs:Item) -> Bool {
    
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.creationdate == rhs.creationdate &&
        lhs.completed == rhs.completed &&
        lhs.completiondate == rhs.completiondate &&
        lhs.tags == rhs.tags &&
        lhs.trashed == rhs.trashed
    
}
