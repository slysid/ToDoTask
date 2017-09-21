//
//  FileHandlingManager.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation
import UIKit

class FileHandlingManager:NSObject {
    
    static let sharedInstance = FileHandlingManager()
    
    // PRIVATE METHODS
    
    private func formDocumentPathWithFile(name:String) -> String {
        
        let documentsDirectory = self.getDocumentsDirectory()
        return (documentsDirectory as NSString).appendingPathComponent(name)
    }
    
    private func getFileTypeFromFileName(name:String) -> [String] {
        
        return name.components(separatedBy: ".")
    }
    
    private func findIndexOfItem(data:[[String:Any]], item:Item) -> Int?{
        
        var index:Int?
        for (idx, d) in data.enumerated() {
            if ((d["id"] as! Int) == item.id) {
                index = idx
                break
            }
        }
        return index
    }
    
    
    // PUBLIC METHODS
    
    public func checkForFileExistenceIn(filepath:String) -> Bool {
        
        return FileManager.default.fileExists(atPath:filepath)
    }
    
    public func getDocumentsDirectory() -> String {
        
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0]
    }
    
    public func checkForFileExistenceInDocuments(file:String) -> Bool {
        
        let filePath = self.formDocumentPathWithFile(name: file)
        return checkForFileExistenceIn(filepath:filePath)
    }
 
    public func copyFileToDocuments(file:String) {
        
        if (self.checkForFileExistenceInDocuments(file:file) == false) {
            
            let fileType = self.getFileTypeFromFileName(name: file)
            let destinationPath = self.formDocumentPathWithFile(name: file)
            let sourcePath = Bundle.main.path(forResource:fileType[0], ofType:fileType[1])
            do {
                try FileManager.default.copyItem(atPath: sourcePath!, toPath: destinationPath)
            }
            catch {
                
                print(error.localizedDescription)
            }
        }
    }
    
    public func readJSONFile(name:String) -> Any? {
        
        guard (self.checkForFileExistenceInDocuments(file:name) == true) else {
            
            return nil
        }
        
        let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: name))
        do {
            
            let fileData = try Data(contentsOf: filePathURL)
            let jsonData = try JSONSerialization.jsonObject(with: fileData, options:[])
            return jsonData
        }
        catch {
            
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func addRecordToJSONFile(name:String, item:Item) throws {
        
        guard (self.checkForFileExistenceInDocuments(file:name) == true) else {
            
            return
        }
        
        let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: name))
        let data = Item.unpack(data: item)
        do {
            
            var existingData = self.readJSONFile(name:name) as! [[String:Any]]
            existingData.append(data)
            let jsonData = try JSONSerialization.data(withJSONObject: existingData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func updateRecordInJSONFile(name:String, item:Item, key:String, value:Any) throws {
        
        guard (self.checkForFileExistenceInDocuments(file:name) == true) else {
            
            return
        }
        
        do {
            
            let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: name))
            var allData = self.readJSONFile(name: name) as! [[String:Any]]
            let index = self.findIndexOfItem(data: allData, item: item)
            var originalData = allData[index!]
            originalData[key] = value
            allData.remove(at: index!)
            allData.insert(originalData, at: index!)
            let jsonData = try JSONSerialization.data(withJSONObject: allData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func deleteRecordFromJSONFile(name:String, item:Item) throws {
        
        guard (self.checkForFileExistenceInDocuments(file:name) == true) else {
            
            return
        }
        
        do {
            
            let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: name))
            var allData = self.readJSONFile(name: name) as! [[String:Any]]
            let index = self.findIndexOfItem(data: allData, item: item)
            allData.remove(at: index!)
            let jsonData = try JSONSerialization.data(withJSONObject: allData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    // SIMULATION METHODS
    
    public func toggleCompletionStatus(item:Item) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        var allData = self.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
        let index = self.findIndexOfItem(data: allData, item: item)
        var selectedData = allData[index!]
        let completionStatus = selectedData["completed"] as! Bool
        do {
           try self.updateRecordInJSONFile(name: DATAFILENAME, item: item, key: "completed", value: !completionStatus)
            try self.updateRecordInJSONFile(name: DATAFILENAME, item: item, key: "completiondate", value: Date().iso8601Short)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func trashItem(item:Item, trash:Bool) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        
        do {
            try self.updateRecordInJSONFile(name: DATAFILENAME, item: item, key: "trashed", value:trash)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func deleteFromTrash(item:Item) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        
        do {
            try self.deleteRecordFromJSONFile(name: DATAFILENAME, item: item)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func reorderItems(item1:Item, item2:Item) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        do {
            
            let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: DATAFILENAME))
            var allData = self.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
            let sourceIndex = self.findIndexOfItem(data: allData, item: item1)
            let destinationIndex = self.findIndexOfItem(data: allData, item: item2)
            allData.swapAt(sourceIndex!, destinationIndex!)
            let jsonData = try JSONSerialization.data(withJSONObject: allData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func editItem(item:Item) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        do {
            
            let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: DATAFILENAME))
            var allData = self.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
            allData.remove(at: (item.id - 1))
            allData.insert(Item.unpack(data: item), at: (item.id - 1))
            let jsonData = try JSONSerialization.data(withJSONObject: allData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func addItem(item:Item) {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return
        }
        do {
            
            var item = item
            let filePathURL = URL.init(fileURLWithPath:self.formDocumentPathWithFile(name: DATAFILENAME))
            var allData = self.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
            item.id = allData.count + 1
            allData.append(Item.unpack(data: item))
            let jsonData = try JSONSerialization.data(withJSONObject: allData, options: [])
            try jsonData.write(to: filePathURL)
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
    
    public func search(text:String) -> [[String:Any]] {
        
        guard (self.checkForFileExistenceInDocuments(file:DATAFILENAME) == true) else {
            return []
        }
        let text = text.lowercased()
        let allData = self.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
        let data = allData.filter{
            
            ($0["name"] as! String).lowercased().range(of: text) != nil ||
            ($0["description"] as! String).lowercased().range(of: text) != nil ||
            ($0["creationdate"] as! String).lowercased().range(of: text) != nil ||
            ($0["completiondate"] as! String).lowercased().range(of: text) != nil ||
            ($0["tags"] as! [String]).contains(text) &&
            ($0["trashed"] as! Bool) == false
        }
        return data
       
    }
}
