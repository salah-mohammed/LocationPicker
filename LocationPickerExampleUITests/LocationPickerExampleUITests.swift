//
//  LocationPickerExampleUITests.swift
//  LocationPickerExampleUITests
//
//  Created by Salah on 3/28/22.
//  Copyright © 2022 Salah. All rights reserved.
//

import XCTest
@testable import LocationPicker
class LocationPickerExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        testSearch(app: app);
        currentLocation(app:app);
        currentLocation2(app:app);
    
                
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
                
                
    
            }
        }
    }
    func testSearch(app:XCUIApplication){
        app/*@START_MENU_TOKEN@*/.staticTexts["present"]/*[[".buttons[\"present\"].staticTexts[\"present\"]",".staticTexts[\"present\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["Search"].tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["ا"]/*[[".keyboards.keys[\"ا\"]",".keys[\"ا\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        app/*@START_MENU_TOKEN@*/.keys["خ"]/*[[".keyboards.keys[\"خ\"]",".keys[\"خ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ت"]/*[[".keyboards.keys[\"ت\"]",".keys[\"ت\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["ب"]/*[[".keyboards.keys[\"ب\"]",".keys[\"ب\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        key.tap()
        
        let key3 = app/*@START_MENU_TOKEN@*/.keys["ر"]/*[[".keyboards.keys[\"ر\"]",".keys[\"ر\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key3.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"بحث\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            print("timeout");
        } else {
            print("not end");
        }
        if app.tables.firstMatch.cells.count > 0{
            XCTAssertTrue(true)
        }else{
            XCTAssertTrue(false)
        }
    }
    func currentLocation(app:XCUIApplication){
        app/*@START_MENU_TOKEN@*/.staticTexts["present"]/*[[".buttons[\"present\"].staticTexts[\"present\"]",".staticTexts[\"present\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
       
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            print("timeout");
        } else {
            print("not end");
        }
        if app.tables.firstMatch.cells.count > 0{
            XCTAssertTrue(true)
        }else{
            XCTAssertTrue(false)
        }
    }
    func currentLocation2(app:XCUIApplication){
        app.buttons["present"].tap()
        let tablesQuery = app.tables
        XCTAssertNotNil(tablesQuery.staticTexts.containing(.any, identifier:"Current Location").element.value)
    }
}
