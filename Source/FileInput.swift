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

public typealias LineOfText = String

public class FileInput: SequenceType {

    public typealias Generator = GeneratorOf<LineOfText>
    
    public func generate() -> Generator {
        return Generator { return self.nextLine() }
    }
    
    convenience public init() {
        self.init( filePath: "-" )
    }
    
    convenience public init( filePath: String ) {
        self.init( filePaths: [filePath] )
    }
    
    public init( filePaths: [String] ) {
        self.filePaths = filePaths
        self.openNextFile()
    }

    public var filePath: String? {
        return filePaths.count > 0 ? filePaths[0] : nil
    }
    
    public func nextLine() -> LineOfText? {
        var result: LineOfText? = self.lines?.nextLine()
        
        while result == nil && self.filePath != nil {
            filePaths.removeAtIndex( 0 )
            self.openNextFile()
            result = self.lines?.nextLine()
        }
        
        return result
    }

    // MARK: - Private
    private var filePaths: [String]
    private var lines: _FileLines? = nil

    private func openNextFile() {
        if let filePath = self.filePath {
            self.lines = _FileLines.linesForFilePath( filePath )
        }
    }
}


// MARK: - Private


private let _stdinPath = "-"

private class _FileLines: SequenceType {

    typealias Generator = GeneratorOf<LineOfText>
    var file: UnsafeMutablePointer<FILE>
    var charBuffer = [CChar]( count: 512, repeatedValue: 0 )
    
    init( file: UnsafeMutablePointer<FILE> ) {
        self.file = file
    }
    
    deinit {
        if file != nil {
            fclose( file )
        }
    }
    
    class func linesForFilePath( filePath: String ) -> _FileLines? {
        var lines: _FileLines? = nil
        
        if filePath == _stdinPath {
            lines = _FileLines( file: __stdinp )
        } else {
            let file = fopen( filePath, "r" )
            if file == nil  {
                println( "can't open \(filePath)" )
            }
            else {
                lines = _FileLines( file: file )
            }
        }
        
        return lines
    }
    
    func generate() -> Generator { return Generator { self.nextLine() } }
    
    func nextChunk() -> String? {
        var result: String? = nil;
    
        if file != nil {
            if fgets( &charBuffer, Int32( charBuffer.count ), file ) != nil {
                result = String.fromCString( charBuffer )
            }
        }
        
        return result
    }
    
    func nextLine() -> LineOfText? {
        var line: LineOfText = LineOfText()
        
        while let nextChunk = self.nextChunk() {
            line += nextChunk
            
            if line.hasSuffix( "\n" ) {
                break
            }
        }
        
        return line.isEmpty ? nil : line
    }
}
