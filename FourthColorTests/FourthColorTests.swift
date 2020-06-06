//
//  FourthColorTests.swift
//  FourthColorTests
//
//  Created by Natalia Wcisło on 16/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import XCTest
import CoreData
@testable import FourthColor

class FourthColorTests: XCTestCase {
    var photoConnection: PhotoConnection? = nil

    override func setUpWithError() throws {
        photoConnection = PhotoConnection()
    }

    override func tearDownWithError() throws {
        
    }

    func testInsertAndDelete() throws {
        let imageData: Data = UIImage(named: "test1")!.pngData()!
        let predicate: (Photo) -> Bool = { p in return p.image == imageData }
        let fetchSpecificPhoto: () -> Photo? = { return self.photoConnection!.fetchPhotos().first(where: predicate) }
        
        photoConnection!.insertPhoto(name: "", image: imageData, color: 0, description: "")
        
        XCTAssertNotNil(fetchSpecificPhoto())
        
        photoConnection!.deletePhoto(where: predicate)
        
        XCTAssertNil(fetchSpecificPhoto())
    }
}
