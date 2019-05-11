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

private func _licenseFilePath() -> String {
    let classBundle = Bundle(for: FileInput_tests.self)
    return classBundle.path(forResource: "LICENSE", ofType: "txt")!
}

private func _readmeFilePath() -> String {
    let classBundle = Bundle(for: FileInput_tests.self)
    return classBundle.path(forResource: "README", ofType: "md")!
}

private func _longLineFilePath() -> String {
    let classBundle = Bundle(for: FileInput_tests.self)
    return classBundle.path(forResource: "long-lines", ofType: "txt")!
}

private func _unicodeFilePath() -> String {
    let classBundle = Bundle(for: FileInput_tests.self)
    return classBundle.path(forResource: "unicode", ofType: "txt")!
}


// MARK: -


extension String {
    var length: Int { return self.characters.count }
}


// MARK: -


class FileInput_tests: XCTestCase {

    func test_defaultFileInput_usesStandardInput() {
        XCTAssertEqual(FileInput.filePath!, "-", "")
    }
    
    func test_badFileInput_returnsNoLines() {
        let lines = FileInput(filePath: _badFilePath())
        XCTAssertNil(lines.nextLine(), "")
    }
    
    func test_badFileInput_iteratesNoLines() {
        var lineWasRetrieved = false
        for _ in FileInput(filePath: _badFilePath()) {
            lineWasRetrieved = true
        }
        XCTAssertFalse(lineWasRetrieved, "")
    }
    
    func test_fileInput_returnsLines() {
        let lines = FileInput(filePath: _licenseFilePath())
        XCTAssertNotNil(lines.nextLine(), "")
    }
    
    func test_fileInput_iteratesLines() {
        var lineWasRetrieved = false
        for _ in FileInput(filePath: _licenseFilePath()) {
            lineWasRetrieved = true
        }
        XCTAssertTrue(lineWasRetrieved, "")
    }
    
    func test_fileInput_canIterateTwoFiles() {
        let licensePath = _licenseFilePath()
        let readmePath = _readmeFilePath()
        let filePaths = [ licensePath, readmePath ]

        var licenseLineCount = 0
        var readmeLineCount = 0
        let lines = FileInput(filePaths: filePaths)
        
        for line in lines {
            switch lines.filePath! {
                case licensePath:
                    switch licenseLineCount {
                        case 0: XCTAssertEqual(line, "The MIT License (MIT)\n", "")
                        case 1: XCTAssertEqual(line, "\n", "")
                        case 2: XCTAssertEqual(line, "Copyright (c) 2014 Otto Schnurr\n", "")
                        default: XCTAssertNotNil(line, "")
                    }
                    licenseLineCount += 1
                case readmePath:
                    switch readmeLineCount {
                        case 0: XCTAssertEqual(line, "FileInput\n", "")
                        case 1: XCTAssertEqual(line, "=========\n", "")
                        case 2: XCTAssertEqual(line, "\n", "")
                        case 3: XCTAssertEqual(line, "A pipe for streaming text from the command line into Swift scripts.\n", "")
                        default: XCTAssertNotNil(line, "")
                    }
                    readmeLineCount += 1
                default:
                    XCTFail("Unknown file path.")
            }
        }
        
        XCTAssertGreaterThan(licenseLineCount, 0, "Failed to parse LICENSE.")
        XCTAssertGreaterThan(readmeLineCount, 0, "Failed to parse README.")
    }
    
    func test_fileInput_preservesLongLines() {
        var lineCount = 0
        for line in FileInput(filePath: _longLineFilePath()) {
            switch lineCount {
                case 0: XCTAssertEqual(line.length, 68, "")
                case 2: XCTAssertEqual(line.length, 407, "")
                case 4: XCTAssertEqual(line.length, 1631, "")
                default: XCTAssertGreaterThan(line.length, 0, "")
            }
            lineCount += 1
        }
        
        XCTAssertGreaterThan(lineCount, 0, "Failed to parse any long lines.")
    }
    
    func test_defaultArgvInput_usesStandardInput() {
        XCTAssertEqual(input().filePath!, "-", "")
    }
    
    func test_unicodeInput_preservesUnicode() {
        let lines = FileInput(filePath: _unicodeFilePath())
        XCTAssertEqual(lines.nextLine()!, "🐶\n", "")
        XCTAssertEqual(lines.nextLine()!, "😄👍", "")
    }
    
    
    // MARK: -
    
    
    func test_removingLeadingSpace() {
        XCTAssertEqual("".removeLeadingSpace(), "", "")
        XCTAssertEqual("\n".removeLeadingSpace(), "", "")
        XCTAssertEqual("   \t\r\n".removeLeadingSpace(), "", "")
        
        XCTAssertEqual("foo".removeLeadingSpace(), "foo", "")
        XCTAssertEqual("\nfoo".removeLeadingSpace(), "foo", "")
        XCTAssertEqual("   \t\r\nfoo".removeLeadingSpace(), "foo", "")

        XCTAssertEqual("foo\n".removeLeadingSpace(), "foo\n", "")
        XCTAssertEqual("\nfoo\n".removeLeadingSpace(), "foo\n", "")
        XCTAssertEqual("   \t\r\nfoo\n".removeLeadingSpace(), "foo\n", "")
        
        XCTAssertEqual("🐶".removeLeadingSpace(), "🐶", "")
        XCTAssertEqual("\n🐶".removeLeadingSpace(), "🐶", "")
        XCTAssertEqual("   \t\r\n🐶".removeLeadingSpace(), "🐶", "")
        
        XCTAssertEqual("🐶\n".removeLeadingSpace(), "🐶\n", "")
        XCTAssertEqual("\n🐶\n".removeLeadingSpace(), "🐶\n", "")
        XCTAssertEqual("   \t\r\n🐶\n".removeLeadingSpace(), "🐶\n", "")
    }
    
    func test_removingTrailingSpace() {
        XCTAssertEqual("".removeTrailingSpace(), "", "")
        XCTAssertEqual("\n".removeTrailingSpace(), "", "")
        XCTAssertEqual("   \t\r\n".removeTrailingSpace(), "", "")
        
        XCTAssertEqual("foo".removeTrailingSpace(), "foo", "")
        XCTAssertEqual("foo\n".removeTrailingSpace(), "foo", "")
        XCTAssertEqual("foo   \t\r\n".removeTrailingSpace(), "foo", "")

        XCTAssertEqual("\nfoo".removeTrailingSpace(), "\nfoo", "")
        XCTAssertEqual("\nfoo\n".removeTrailingSpace(), "\nfoo", "")
        XCTAssertEqual("\nfoo   \t\r\n".removeTrailingSpace(), "\nfoo", "")
        
        XCTAssertEqual("🐶".removeTrailingSpace(), "🐶", "")
        XCTAssertEqual("🐶\n".removeTrailingSpace(), "🐶", "")
        XCTAssertEqual("🐶   \t\r\n".removeTrailingSpace(), "🐶", "")
        
        XCTAssertEqual("\n🐶".removeTrailingSpace(), "\n🐶", "")
        XCTAssertEqual("\n🐶\n".removeTrailingSpace(), "\n🐶", "")
        XCTAssertEqual("\n🐶   \t\r\n".removeTrailingSpace(), "\n🐶", "")
    }
    
    
    // MARK: -
    
    
    func test_missingSpace_canNotBeFound() {
        XCTAssertTrue("".findFirstSpace() == nil, "")
        XCTAssertTrue("foo".findFirstSpace() == nil, "")
        XCTAssertTrue("🐶".findFirstSpace() == nil, "")
    }

    func test_space_canBeFound() {
        let newline = "\n"
        let spaces = "   \t\r\n"
        XCTAssertEqual(newline.findFirstSpace()!, newline.startIndex, "")
        XCTAssertEqual(spaces.findFirstSpace()!, spaces.startIndex, "")
    }
    
    func test_leadingSpace_canBeFound() {
        let newlineFoo = "\nfoo"
        let newlineDog = "\n🐶"
        XCTAssertEqual(newlineFoo.findFirstSpace()!, newlineFoo.startIndex, "")
        XCTAssertEqual(newlineDog.findFirstSpace()!, newlineDog.startIndex, "")
        
        let spaceFoo = "   \t\r\nfoo"
        let spaceDog = "   \t\r\n🐶"
        XCTAssertEqual(spaceFoo.findFirstSpace()!, spaceFoo.startIndex, "")
        XCTAssertEqual(spaceDog.findFirstSpace()!, spaceDog.startIndex, "")
    }
    
    func test_trailingSpace_canBeFound() {
        let fooNewline = "foo\n"
        let dogNewline = "🐶\n"
        XCTAssertEqual(
            fooNewline.findFirstSpace()!,
            fooNewline.characters.index(fooNewline.startIndex, offsetBy: 3),
            ""
        )
        XCTAssertEqual(
            dogNewline.findFirstSpace()!,
            dogNewline.characters.index(dogNewline.startIndex, offsetBy: 1),
            ""
        )
        
        let fooSpace = "foo   \t\r\n"
        let dogSpace = "🐶   \t\r\n"
        XCTAssertEqual(
            fooSpace.findFirstSpace()!,
            fooSpace.characters.index(fooSpace.startIndex, offsetBy: 3),
            ""
        )
        XCTAssertEqual(
            dogSpace.findFirstSpace()!,
            dogSpace.characters.index(dogSpace.startIndex, offsetBy: 1),
            ""
        )
    }
}
