//
//  TableModelDemoTests.swift
//  TableModelDemoTests
//
//  Created by Alexander Lonsky on 12/2/14.
//  Copyright (c) 2014 SHAPE. All rights reserved.
//

import UIKit
import XCTest

class TableModelDemoTests: XCTestCase {
    
    lazy var model = TableModel()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModel() {
        XCTAssertEqual(model.numberOfSections(), 0, "Wrong number of sections")

        model.addSectionWithId(3)
        model.addSectionWithId(5)
        model.addSectionWithId(7)
        model.addSectionWithId(9)
        model.addSectionWithId(11)
        
        XCTAssertEqual(model.numberOfSections(), 5, "wrong number of sections")
        
        if let indexOfLastSection = model.indexOfSectionWithId(11) {
            XCTAssertEqual(indexOfLastSection, 4, "wrong number of sections")
        }
        else {
            XCTFail("inconsistency: existing section not found")
        }
        
        model.removeSectionWithId(9)
        if let indexOfRemovedSection = model.indexOfSectionWithId(9) {
            XCTFail("inconsistency: section with removed Id is still in the model")
        }
        model.removeSectionWithId(5)
        model.removeSectionWithId(0)

        XCTAssertEqual(model.numberOfSections(), 3, "Wrong number of sections")
        
        model.insertSectionWithId(13, atIndex: 1)
        XCTAssertEqual(model.numberOfSections(), 4, "Wrong number of sections")
        model.insertSectionWithId(14, atIndex: 111)
        XCTAssertEqual(model.numberOfSections(), 5, "Wrong number of sections")
        if let indexOfLastSection = model.indexOfSectionWithId(14) {
            XCTAssertEqual(indexOfLastSection, 4, "Wrong section index")
        }
        else {
            XCTFail("inconsistency: index of existing section not found")
        }
        model.insertSectionWithId(15, atIndex: 5)
        XCTAssertEqual(model.numberOfSections(), 6, "Wrong number of sections")
        if let indexOfNewSection = model.indexOfSectionWithId(15) {
            XCTAssertEqual(indexOfNewSection, 5, "Wrong section index")
        }
        else {
            XCTFail("inconsistency: index of existing section not found")
        }
        
        model.addCellWithId(1, toSectionWithId: 3)
        model.addCellWithId(2, toSectionWithId: 3)
        model.addCellWithId(1, toSectionWithId: 3)

        var indexPath = NSIndexPath(forRow: 1, inSection: 0)
        if let cellIdForExistingIndexPath = model.cellIdForIndexPath(indexPath) {
            XCTAssertEqual(cellIdForExistingIndexPath, 2, "Can't find cellId for indexPath")
        }
        else {
            XCTFail("inconsistency: cellIdForIndexPath failed")
        }

        if let resultIndexPath = model.indexPathForCellWithId(2) {
            XCTAssertEqual(resultIndexPath.row, 1, "wrong row")
            XCTAssertEqual(resultIndexPath.section, 0, "wrong section")
        }
        else {
            XCTFail("can't return indexPath for an existing cell")
        }
        
        model.addCellWithId(1, toSectionWithId: 9)
        model.addCellWithId(2, toSectionWithId: 9)
        model.addCellWithId(1, toSectionWithId: 9)
        model.addCellWithId(3, toSectionWithId: 9)
        
        model.addCellWithId(1)
        model.addCellWithId(2)
        model.addCellWithId(3)
        model.addCellWithId(4)
        model.addCellWithId(5)
        XCTAssertEqual(model.numberOfRows(), 5, "Wrong number of rows in section")
        
        XCTAssertEqual(model.numberOfRowsForSectionWithId(3), 2, "Wrong number of rows in section")
        XCTAssertEqual(model.numberOfRowsForSectionWithId(7), 0, "Wrong number of rows in section")
        XCTAssertEqual(model.numberOfRowsForSectionWithId(9), 3, "Wrong number of rows in section")
        
        indexPath = NSIndexPath(forRow: 1, inSection: 0)
        XCTAssertEqual(model.cellIdForIndexPath(indexPath)!, 2, "wrong cellId")
        
        model.removeCellAtIndexPath(indexPath)
        if let removedCellId = model.cellIdForIndexPath(indexPath) {
            XCTAssertNotEqual(removedCellId, 2, "removed cell is still in the model")
        }
        
        model.resetModel()
        XCTAssertEqual(model.numberOfRowsForSectionWithId(3), 0, "Wrong number of rows in section")
        XCTAssertEqual(model.numberOfRowsForSectionWithId(333), 0, "Wrong number of rows in section")
        XCTAssertEqual(model.numberOfSections(), 0, "Wrong number of sections")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
