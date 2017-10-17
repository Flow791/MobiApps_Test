//
//  MobiApp_TestUITests.swift
//  MobiApp_TestUITests
//
//  Created by Florian Baudin on 13/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import XCTest

class MobiApp_TestUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTableView() {
        app.launch()
        
        app.tables.staticTexts["squirtle"].tap()
        
        XCTAssertTrue(app.isDisplayingPokemonView)
    }
    
    func testPokemonView() {
        
        testTableView()
        XCTAssertTrue(app.staticTexts["squirtle"].exists)
        
        app.navigationBars["MobiApp_Test.PokemonInfoView"].buttons["Share"].tap()
        app.buttons["Cancel"].tap()
    }
}

extension XCUIApplication {
    var isDisplayingPokemonView: Bool {
        return otherElements["pokemonView"].exists
    }
}
