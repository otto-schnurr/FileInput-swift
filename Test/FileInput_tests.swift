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

private func _goodFilePath() -> String {
    let classBundle = NSBundle( forClass: FileInput_tests.self )
    return classBundle.pathForResource( "LICENSE", ofType: "txt" )
}

class FileInput_tests: XCTestCase {

    func test_defaultFileInput_usesStandardInput() {
        XCTAssertEqual( FileInput().filePath!, "-", "" )
    }
    
    func test_badFileInput_returnsNoLines() {
        var lines = FileInput( filePath: _badFilePath() )
        XCTAssertNil( lines.nextLine(), "" )
    }
    
    func test_badFileInput_iteratesNoLines() {
        var lineWasRetrieved = false
        for line in FileInput( filePath: _badFilePath() ) {
            lineWasRetrieved = true
        }
        XCTAssertFalse( lineWasRetrieved, "" )
    }
    
    func test_goodFileInput_returnsLines() {
        var lines = FileInput( filePath: _goodFilePath() )
        XCTAssertNotNil( lines.nextLine(), "" )
    }
    
    func test_goodFileInput_iteratesLines() {
        var lineWasRetrieved = false
        for line in FileInput( filePath: _goodFilePath() ) {
            lineWasRetrieved = true
        }
        XCTAssertTrue( lineWasRetrieved, "" )
    }
    
}
