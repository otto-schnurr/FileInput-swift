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

/// :returns: A FileInput sequence to iterate over lines of all files
///           listed in command line arguments. If that list is empty 
///           then standard input is used.
///
///           A file path of "-" is replaced with standard input.
public func input() -> FileInput {
	var arguments = [String]()

	for index in 0 ..< Int( C_ARGC ) {
        switch index {
            case 0: continue
            default:
                if let argument = String.fromCString( C_ARGV[index] ) {
                    arguments.append( argument )
                }
        }
	}

	let filePaths = [String]( arguments.count > 0 ? arguments : ["-"] )
	return FileInput( filePaths: filePaths )
}


// MARK: -


/// A collection of characters typically ending with a newline.
/// The last line of a file might not contain a newline.
public typealias LineOfText = String

/// A sequence that vends LineOfText objects.
public class FileInput: SequenceType {

    public typealias Generator = GeneratorOf<LineOfText>
    
    public func generate() -> Generator {
        return Generator { return self.nextLine() }
    }
    
    /// Constructs a sequence to iterate lines of standrd input.
    convenience public init() {
        self.init( filePath: "-" )
    }
    
    /// Constructs a sequence to iterate lines of a file.
    /// A filePath of "-" is replaced with standard input.
    convenience public init( filePath: String ) {
        self.init( filePaths: [filePath] )
    }
    
    /// Constructs a sequence to iterate lines over a collection of files.
    /// Each filePath of "-" is replaced with standard input.
    public init( filePaths: [String] ) {
        self.filePaths = filePaths
        self.openNextFile()
    }

    /// The file used in the last call to nextLine().
    public var filePath: String? {
        return filePaths.count > 0 ? filePaths[0] : nil
    }
    
    /// Newline characters that delimit lines are not removed.
    public func nextLine() -> LineOfText? {
        var result: LineOfText? = self.lines?.nextLine()
        
        while result == nil && self.filePath != nil {
            filePaths.removeAtIndex( 0 )
            self.openNextFile()
            result = self.lines?.nextLine()
        }
        
        return result
    }

    // MARK: Private
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
