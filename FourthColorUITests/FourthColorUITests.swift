//
//  FourthColorUITests.swift
//  FourthColorUITests
//
//  Created by Natalia Wcisło on 06/06/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import XCTest
@testable import FourthColor

class FourthColorUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testColorBlindnessInformation() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.swipeUp()
        app.swipeUp()
        app.buttons["Color Blindness"].tap()
        
        XCTAssertTrue(app.isDisplayingColorBlindnessInformation)
    }
    
    func testCameraAndGallery() throws {
        let app = XCUIApplication()
        app.launchArguments.append("isUITesting")
        app.launch()
        
        app.buttons["Deuteranomaly"].tap()
        
        XCTAssertTrue(app.isDisplayingCamera)
        //ref do kamery
        let cameraElement = app.otherElements["camera"]
        
        if cameraElement.waitForExistence(timeout: 5) {
            cameraElement.doubleTap()
        }
        
        app.buttons["backButton"].tap()
       // strawdzam czy nie wyswietlam glownego zdj w galerii
        XCTAssertFalse(app.isDisplayingMainPhoto)
        
        app.swipeUp()
        app.swipeUp()
        app.buttons["Gallery"].tap()
        app.images["galleryPhoto0"].tap()
         // strawdzam czy  wyswietlam glowne zdj w galerii
        XCTAssertTrue(app.isDisplayingMainPhoto)
        
        app.buttons["backButton"].tap()
        
        app.buttons["Home"].tap()
        // strawdzam czy nie wyswietlam glownego zdj w galerii
        XCTAssertFalse(app.isDisplayingMainPhoto)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

//  istniej na ekranie
extension XCUIApplication {
    var isDisplayingColorBlindnessInformation: Bool {
        return staticTexts["colorBlindnessInformation"].exists
    }
    
    var isDisplayingMainPhoto: Bool {
        return images["mainPhoto"].exists
    }
    
    var isDisplayingCamera: Bool {
        return otherElements["camera"].exists
    }
}
