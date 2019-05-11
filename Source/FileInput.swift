//
//  FileInput.swift
//
//  Created by Otto Schnurr on 8/23/2014.
//  Copyright (c) 2014 Otto Schnurr. All rights reserved.
//
//  MIT License
//     file: ../../LICENSE.txt
//     http://opensource.org/licenses/MIT
//

import Darwin

/// Creates a FileInput sequence to iterate over lines of all files listed
/// in command line arguments. If that list is empty then standard input is
/// used.
///
/// A file path of "-" is replaced with standard input.
public func input() -> FileInput {
    var arguments = [String]()

    for index in 0 ..< Int(CommandLine.argc) {
        switch index {
            case 0: continue
            default:
                if let argument = String(validatingUTF8: Process.unsafeArgv[index]) {
                    arguments.append(argument)
                }
        }
    }

    let filePaths = [String](arguments.count > 0 ? arguments : ["-"])
    return FileInput(filePaths: filePaths)
}


// MARK: -


/// A collection of characters typically ending with a newline.
/// The last line of a file might not contain a newline.
public typealias LineOfText = String

/// A sequence that vends LineOfText objects.
open class FileInput: Sequence {

    public typealias Iterator = AnyIterator<LineOfText>
    
    open func makeIterator() -> Iterator {
        return AnyIterator { return self.nextLine() }
    }
    
    /// Constructs a sequence to iterate lines of standrd input.
    convenience public init() {
        self.init(filePath: "-")
    }
    
    /// Constructs a sequence to iterate lines of a file.
    /// A filePath of "-" is replaced with standard input.
    convenience public init(filePath: String) {
        self.init(filePaths: [filePath])
    }
    
    /// Constructs a sequence to iterate lines over a collection of files.
    /// Each filePath of "-" is replaced with standard input.
    public init(filePaths: [String]) {
        self.filePaths = filePaths
        self.openNextFile()
    }

    /// The file used in the previous call to nextLine().
    open var filePath: String? {
        return filePaths.count > 0 ? filePaths[0] : nil
    }
    
    /// Newline characters that delimit lines are not removed.
    open func nextLine() -> LineOfText? {
        var result: LineOfText? = self.lines?.nextLine()
        
        while result == nil && self.filePath != nil {
            filePaths.remove(at: 0)
            self.openNextFile()
            result = self.lines?.nextLine()
        }
        
        return result
    }

    // MARK: Private
    fileprivate var filePaths: [String]
    fileprivate var lines: _FileLines? = nil

    fileprivate func openNextFile() {
        if let filePath = self.filePath {
            self.lines = _FileLines.linesForFilePath(filePath)
        }
    }
}


// MARK: -


extension String {

    /// Creates a copy of this string with no white space at the beginning.
    public func removeLeadingSpace() -> String {
        let characters = self.unicodeScalars
        var start = characters.startIndex
        
        while start < characters.endIndex {
            if !characters[start].isSpace() {
                break
            }
            
            start = <#T##Collection corresponding to `start`##Collection#>.index(after: start)
        }
        
        return String(characters[start..<characters.endIndex])
    }

    /// Creates a copy of this string with no white space at the end.
    public func removeTrailingSpace() -> String {
        let characters = self.unicodeScalars
        var end = characters.endIndex
        
        while characters.startIndex < end {
            let previousIndex = <#T##Collection corresponding to `end`##Collection#>.index(before: end)
            
            if !characters[previousIndex].isSpace() {
                break
            }
            
            end = previousIndex
        }
        
        return String(characters[characters.startIndex..<end])
    }
    
    /// - returns: An index of the first white space character in this string.
    public func findFirstSpace() -> String.Index? {
        var result: String.Index? = nil
        
        for index in self.characters.indices {
            if self[index].isSpace() {
                result = index
                break
            }
        }

        return result
    }
}


// MARK: - Private


private let _stdinPath = "-"

private class _FileLines: Sequence {

    typealias Iterator = AnyIterator<LineOfText>
    let file: UnsafeMutablePointer<FILE>?
    var charBuffer = [CChar](repeating: 0, count: 512)
    
    init(file: UnsafeMutablePointer<FILE>) {
        self.file = file
    }
    
    deinit {
        if file != nil {
            fclose(file)
        }
    }
    
    class func linesForFilePath(_ filePath: String) -> _FileLines? {
        var lines: _FileLines? = nil
        
        if filePath == _stdinPath {
            lines = _FileLines(file: __stdinp)
        } else {
            let file = fopen(filePath, "r")
            if file == nil  {
                print("can't open \(filePath)")
            }
            else {
                lines = _FileLines(file: file!)
            }
        }
        
        return lines
    }
    
    func makeIterator() -> Iterator { return AnyIterator { self.nextLine() } }
    
    func nextChunk() -> String? {
        var result: String? = nil;
    
        if file != nil {
            if fgets(&charBuffer, Int32(charBuffer.count), file) != nil {
                result = String(cString: charBuffer)
            }
        }
        
        return result
    }
    
    func nextLine() -> LineOfText? {
        var line: LineOfText = LineOfText()
        
        while let nextChunk = self.nextChunk() {
            line += nextChunk
            
            if line.hasSuffix("\n") {
                break
            }
        }
        
        return line.isEmpty ? nil : line
    }
}


// MARK: - Private


extension Character {
    fileprivate func isSpace() -> Bool {
        let characterString = String(self)
        for uCharacter in characterString.unicodeScalars {
            if !uCharacter.isSpace() {
                return false
            }
        }
        
        return true
    }
}

extension UnicodeScalar {
    fileprivate func isSpace() -> Bool {
        let wCharacter = wint_t(self.value)
        return iswspace(wCharacter) != 0
    }
}
