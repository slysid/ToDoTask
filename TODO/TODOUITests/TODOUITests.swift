//
//  TODOUITests.swift
//  TODOUITests
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import XCTest

class TODOUITests: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //app.terminate()
    }
    
    func testViewControllerViews() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let addButton = app.buttons["add"]
        let trashButton = app.buttons["trash"]
        let searchField = app.tables.searchFields["Search"]
        let tableCell = app.tables.cells.element
        
        XCTAssertTrue(addButton.exists)
        XCTAssertTrue(trashButton.exists)
        XCTAssertTrue(searchField.exists)
        XCTAssertTrue(tableCell.exists)
    }
    
    func testAddNewRecord() {
        
        let cellCount = app.tables.cells.count
        
        app.buttons["add"].tap()
        
        let addATitleTextField = app.textFields["Add a Title"]
        addATitleTextField.tap()
        addATitleTextField.typeText("test")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let textView = element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        textView.typeText("description")
        
        let addATagTextField = app.textFields["Add a Tag"]
        addATagTextField.tap()
        addATagTextField.tap()
        addATagTextField.typeText("custom")
        element.children(matching: .button)["ADD"].tap()
        element.children(matching: .other).element(boundBy: 1).buttons["ADD"].tap()
        
        XCTAssertTrue(app.tables.cells.count == cellCount + 1)
        
        let cells = app.tables.cells
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons["Delete"].tap()
        
        XCTAssertTrue(app.tables.cells.count == cellCount)
    }
    
    func testDeleteFromTrash() {
        
        testAddNewRecord()
        
        app.buttons["trash"].tap()
        
        let trashedCellCount = app.tables.cells.count
        
        let cells = app.tables.cells
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons["Delete"].tap()
        
        XCTAssertTrue(app.tables.cells.count == trashedCellCount - 1)
    }
    
    func testRecoverFromTrash() {
        
        testAddNewRecord()
        
        let cellCount = app.tables.cells.count
        
        app.buttons["trash"].tap()
        
        let trashedCellCount = app.tables.cells.count
        
        let cells = app.tables.cells
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons["Restore"].tap()
        
        XCTAssertTrue(app.tables.cells.count == trashedCellCount - 1)
        
        app.buttons["document"].tap()
        
        XCTAssertTrue(app.tables.cells.count == cellCount + 1)
    }
    
    func testToDoCompletion() {
        
        let cell = app.tables.cells.element(boundBy: 0)
        if (cell.buttons["target"].exists == true) {
            
            cell.buttons["target"].tap()
            XCTAssertTrue(cell.buttons["completed"].exists)
        }
        
        if (cell.buttons["completed"].exists == true) {
            
            cell.buttons["completed"].tap()
            XCTAssertTrue(cell.buttons["target"].exists)
        }
        
    }
    
}
