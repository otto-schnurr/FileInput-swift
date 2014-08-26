//
//  FileInput_tests.swift
//
//  Created by Otto Schnurr on 8/23/2014.
//  Copyright (c) 2014 Otto Schnurr. All rights reserved.
//
//  MIT License
//     file: ../../LICENSE.txt
//     http://opensource.org/licenses/MIT
//

import Cocoa
import XCTest
import FileInput

class FileInput_tests: XCTestCase {
    func test_defaultFileInput_usesStandardInput() {
        XCTAssertEqual( FileInput().filename!, "-", "" )
    }
}
