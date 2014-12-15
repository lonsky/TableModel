//
//  TableModel.swift
//  TableModel
//
//  Created by Alexander Lonsky on 12/2/14.
//  Copyright (c) 2014 SHAPE. All rights reserved.
//

import Foundation

//Notes:
//not thread-safe
//if we don't have sections - number of sections always return 0       (may be changed in future)
//if we don't have rows in sections or even don't have specified section - number of rows always return 0 (may be changed in future)

private class SectionModel {
    let id : Int
    var cells : [Int]
    
    init(id : Int, cells : [Int]) {
        self.id = id
        self.cells = cells
    }
}

class TableModel {
    let defaultSectionId : Int = -1
    private lazy var model = [SectionModel]()
    
    // MARK: Access model
    func numberOfSections() -> Int {
        return model.count
    }
    
    func numberOfRows() -> Int {
        return numberOfRowsForSectionWithId(defaultSectionId)
    }
    
    func numberOfRowsForSectionWithId(sectionId : Int) -> Int {
        if let section = findSectionWithId(sectionId) {
            return section.cells.count
        }
        return 0
    }

    func numberOfRowsForSectionWithIndex(sectionIndex : Int) -> Int {
        var result : Int = 0
        if let sectionId = sectionIdBySectionIndex(sectionIndex) {
            result = numberOfRowsForSectionWithId(sectionId)
        }
        return result
    }
    
    func indexOfSectionWithId(sectionId : Int) -> Int? {
        for (index, section) in enumerate(model) {
            if section.id == sectionId {
                return index
            }
        }
        return nil
    }
    
    func sectionIdBySectionIndex(sectionIndex : Int) -> Int? {
        if sectionIndex < 0 || sectionIndex >= model.count {
            return nil
        }
        let section = model[sectionIndex]
        return section.id
    }
    
    func sectionIdByIndexPath(indexPath : NSIndexPath) -> Int? {
        return sectionIdBySectionIndex(indexPath.section)
    }
    
    func cellIdForIndexPath(indexPath : NSIndexPath) -> Int? {
        if let section = findSectionByIndex(indexPath.section) {
            let cells = section.cells
            if indexPath.row >= 0 && indexPath.row < cells.count {
                let cellId = cells[indexPath.row]
                return cellId
            }
        }
        return nil
    }
    
    func indexPathForCellWithId(cellId : Int) -> NSIndexPath? {
        for (sectionIndex, section) in enumerate(model) {
            for (rowIndex, storedCellId) in enumerate(section.cells) {
                if(storedCellId == cellId) {
                    let result = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                    return result
                }
            }
        }
        return nil
    }
    
    // MARK: Create model
    func insertSectionWithId(sectionId : Int, atIndex index : Int) {
        if (findSectionWithId(sectionId) != nil) {
            return
        }
        let section = SectionModel(id: sectionId, cells: [])
        if index >= 0 && index < model.count {
            model.insert(section, atIndex: index)
        }
        else {
            model.append(section)
        }
    }
    
    func addSectionWithId(newSectionId : Int) {
        if (findSectionWithId(newSectionId) != nil) {
            return
        }
        
        let section = SectionModel(id: newSectionId, cells: [])
        model.append(section)
    }
    
    func addCellWithId(cellId : Int, toSectionWithId sectionId : Int) {
        //add section if it doesn't exist
        addSectionWithId(sectionId)
        
        //section must exists here
        let section : SectionModel! = findSectionWithId(sectionId)
        
        let indexOfExistingCell = indexOfCell(cellId: cellId, inSection: section)
        if  indexOfExistingCell != nil {
            return
        }
        section.cells.append(cellId)
    }
    
    func insertCellWithId(cellId : Int, intoSectionWithId sectionId: Int, atIndex index: Int) {
        if let section = findSectionWithId(sectionId) {
            let indexOfExistingCell = indexOfCell(cellId: cellId, inSection: section)
            if indexOfExistingCell == nil {
                if index < 0 || index >= section.cells.count {
                    section.cells.append(cellId)
                }
                else {
                    section.cells.insert(cellId, atIndex: index)
                }
            }
        }
    }
    
    func addCellWithId(cellId : Int) {
        addCellWithId(cellId, toSectionWithId: defaultSectionId)
    }
    
    // MARK: Edit model
    func removeSectionWithId(sectionId : Int) {
        let index = indexOfSectionWithId(sectionId)
        if index != nil {
            model.removeAtIndex(index!)
        }
    }
    
    func removeCellAtIndexPath(indexPath: NSIndexPath) {
        if let section = findSectionByIndex(indexPath.section) {
            if indexPath.row >= 0 && indexPath.row < section.cells.count {
                section.cells.removeAtIndex(indexPath.row)
            }
        }
    }
    
    func removeCellWithId(cellId: Int) {
        if let indexPath = indexPathForCellWithId(cellId) {
            removeCellAtIndexPath(indexPath)
        }
    }
    
    func removeCellWithId(cellId: Int, fromSectionWithId sectionId: Int) {
        if let section = findSectionWithId(sectionId) {
            for (index, storedCellId) in enumerate(section.cells) {
                if storedCellId == cellId {
                    section.cells.removeAtIndex(index)
                    break
                }
            }
        }
    }
    
    // MARK: Remove model
    func resetModel(#keepCapacity : Bool) {
        model.removeAll(keepCapacity: keepCapacity)
    }
    
    func resetModel() {
        resetModel(keepCapacity: true)
    }

    // MARK: Private utils methods
    private func findSectionWithId(sectionId : Int) -> SectionModel? {
        for section in model {
            if section.id == sectionId {
                return section
            }
        }
        return nil
    }

    private func findSectionByIndex(sectionIndex: Int) -> SectionModel? {
        if sectionIndex >= 0 && sectionIndex < model.count {
            return model[sectionIndex]
        }
        return nil
    }
    
    private func indexOfCell(#cellId : Int, inSection section : SectionModel) -> Int? {
        for (index, storedCellId) in enumerate(section.cells) {
            if storedCellId == cellId {
                return index
            }
        }
        return nil
    }
}