//
//  ModelTests.swift
//  TODOTests
//
//  Created by Bharath on 2017-09-23.
//  Copyright © 2017 Bharath. All rights reserved.
//

import XCTest
@testable import TODO

class ModelTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testItemWithDict() {
        
        let data:[String:Any] = ["id":1,"name":"test",
                    "description":"test description",
                    "creationdate":"23-09-2017",
                    "completed":false,
                    "completiondate":"",
                    "tags":[],
                    "trashed":false]
        let item = Item(dictionary: data)
        
        XCTAssertTrue(item.id == 1)
        XCTAssertTrue(item.name == "test")
        XCTAssertTrue(item.description == "test description")
        XCTAssertTrue(item.creationdate == "23-09-2017")
        XCTAssertTrue(item.completed == false)
        XCTAssertTrue(item.tags == [])
        XCTAssertTrue(item.completiondate == "")
        XCTAssertTrue(item.trashed == false)
    }
    
    func testItemEquality() {
        
        let item1 = Item()
        let item2 = Item()
        XCTAssertTrue(item1 == item2)
    }
    
    func testItemUnpack() {
        
        let item = Item()
        let itemDict = Item.unpack(data: item)
        
        XCTAssertTrue(itemDict["id"] as! Int == item.id)
    }
    
}
