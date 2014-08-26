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
        get {
            return filePaths.count > 0 ? filePaths[0] : nil
        }
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
            self.lines = _FileLines.linesForFilename( filePath )
        }
    }
}


// MARK: - Private


private let _stdinName = "-"

private class _FileLines: SequenceType {

    typealias Generator = GeneratorOf<LineOfText>
    typealias CharBuffer = UnsafeMutableBufferPointer<CChar>
    
    var file: UnsafeMutablePointer<FILE>
    var chars = Array<CChar>( count: 512, repeatedValue: 0 )
    
    init( file: UnsafeMutablePointer<FILE> ) {
        self.file = file
    }
    
    deinit {
        if file != nil {
            fclose( file )
        }
    }
    
    class func linesForFilename( filename: String ) -> _FileLines? {
        var lines: _FileLines? = nil
        
        if filename == _stdinName {
            lines = _FileLines( file: __stdinp )
        } else {
            let file = fopen( filename, "r" )
            if file == nil  {
                println( "can't open \(filename)" )
            }
            else {
                lines = _FileLines( file: file )
            }
        }
        
        return lines
    }
    
    func generate() -> Generator {
        return Generator { self.nextLine() }
    }
    
    func nextChunk() -> String? {
        func readFileToBuffer( inout buffer: CharBuffer ) -> String? {
            var result: String? = nil
            let bufferSize = Int32( buffer.endIndex - buffer.startIndex )
            let bufferPointer = buffer.baseAddress
            
            if file != nil && bufferSize != 0 {
                if fgets( bufferPointer, bufferSize, self.file ) != nil {
                    result = String.fromCString( bufferPointer )
                }
            }
            
            return result
        }
        
        return chars.withUnsafeMutableBufferPointer( readFileToBuffer )
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
