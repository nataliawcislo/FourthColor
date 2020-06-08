//
//  RecognitionTests.swift
//  FourthColorTests
//
//  Created by Natalia Wcisło on 07/06/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import XCTest
import CoreData
@testable import FourthColor

// test rozpoznawania kolorów
class RecognitionTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        
    }

    func testSimpleColorRecognition() throws {
        let colorSet = ColorSet([
            ("Red", 255, 0, 0, "This is a red color"),
            ("Green", 0, 255, 0, "This ia a green color"),
        ])
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.9, green: 0.0, blue: 0.0, alpha: 1.0))!.name,
            "Red"
        )
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.7, green: 0.3, blue: 0.0, alpha: 1.0))!.name,
            "Red"
        )
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.1, green: 0.8, blue: 0.0, alpha: 1.0))!.name,
            "Green"
        )
    }
    
    func testAdvancedColorRecognition() throws {
        let colorSet = ColorSet([
            ("Red", 255, 0, 0, "This is a red color"),
            ("Green", 0, 255, 0, "This ia a green color"),
            ("Blue", 0, 0, 255, "This ia a blue color"),
            ("Black", 0, 0, 0, "This ia a black color"),
            ("White", 255, 255, 255, "This ia a white color"),
        ])
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.1, green: 0.0, blue: 0.0, alpha: 1.0))!.name,
            "Black"
        )
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0))!.name,
            "Red"
        )
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0))!.name,
            "White"
        )
        
        XCTAssertEqual(
            colorSet.getNearest(from: UIColor(red: 0.0, green: 0.0, blue: 0.9, alpha: 1.0))!.name,
            "Blue"
        )
    }
}
