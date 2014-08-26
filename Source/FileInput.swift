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
        return Generator { nil }
    }
    
    public init() { }
    
    public init( filePath: String ) { }
    
    public var filePath: String? {
        get { return "-" }
    }
    
}
