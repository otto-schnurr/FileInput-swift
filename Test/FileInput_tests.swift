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

private func _badFilePath() -> String {
    return "foo"
}

class FileInput_tests: XCTestCase {

    func test_defaultFileInput_usesStandardInput() {
        XCTAssertEqual( FileInput().filePath!, "-", "" )
    }
    
    func test_badFileInput_iteratesNoLines() {
        var lineWasRetrieved = false
        for line in FileInput( filePath: _badFilePath() ) {
            lineWasRetrieved = true
        }
        XCTAssertFalse( lineWasRetrieved, "" )
    }
}
