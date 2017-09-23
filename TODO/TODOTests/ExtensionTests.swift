//
//  ExtensionTests.swift
//  TODOTests
//
//  Created by Bharath on 2017-09-23.
//  Copyright © 2017 Bharath. All rights reserved.
//

import XCTest
@testable import TODO


class ExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDictExtensionItem() {
        
        let data:[String:Any] = ["id":1,"name":"test",
                                 "description":"test description",
                                 "creationdate":"23-09-2017",
                                 "completed":false,
                                 "completiondate":"",
                                 "tags":[],
                                 "trashed":false]
        
        let item1 = data.item()
        let item2 = Item.init(dictionary: data)
        XCTAssertTrue(item1 == item2)
        
        
        
    }
}
