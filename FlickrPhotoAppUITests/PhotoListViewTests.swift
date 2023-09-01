//
//  PhotoListViewTests.swift
//  FlickrPhotoAppTests
//
//  Created by Mogis A on 31/08/2023.
//

import XCTest
@testable import FlickrPhotoApp

class PhotoListViewTests: XCTestCase {

    var app: XCUIApplication!
    let tableIdentifier = "photoListViewTable"
    let searchKeyword = "Cars"
    let timeout: TimeInterval = 5

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    // MARK: - Utility Methods
    
    func performSearch() {
        let searchBar = app.otherElements["photoSearchBar"]
        searchBar.tap()
        searchBar.typeText(searchKeyword)
        app.keyboards.buttons["Search"].tap()
    }
    
    // MARK: - Test Cases
    
    /// Test to verify the presence of the table view.
    func testPresenceOfTableView() {
        let tableView = app.descendants(matching: .any).matching(identifier: tableIdentifier).firstMatch
        XCTAssertTrue(tableView.exists)
    }

    /// Test to check if the cells in the table view are populated.
    func testCellPopulation() {
        performSearch()
        
        let tableView = app.descendants(matching: .any).matching(identifier: tableIdentifier).firstMatch
        let cell = tableView.cells.staticTexts["Jaguar XKE"]
        XCTAssertTrue(cell.exists, "Cell with title 'Jaguar XKE' should exist")
    }

    /// Test to verify the behavior when a cell is tapped.
    func testCellTap() {
        performSearch()
        
        let tableView = app.descendants(matching: .any).matching(identifier: tableIdentifier).firstMatch
        let cell = tableView.cells.staticTexts["Jaguar XKE"]
        
        if cell.exists {
            cell.tap()
            XCTAssertTrue(app.scrollViews["detailView"].exists, "Detail view should appear when a cell is tapped")
        } else {
            XCTFail("Cell with title 'Jaguar XKE' does not exist")
        }
    }
    
    /// Test to verify the search functionality.
    func testSearchFunctionality() {
        performSearch()
        
        let tableView = app.descendants(matching: .any).matching(identifier: tableIdentifier).firstMatch
        XCTAssert(tableView.cells.count > 0, "At least one cell should exist when searching for '\(searchKeyword)'")
    }
}
