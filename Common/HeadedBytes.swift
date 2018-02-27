//
//  MutableBytes.swift
//  MIDIRawData
//
//  Created by Jan Ratschko on 26.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation


protocol TypedHeadedBytes {
    associatedtype HeaderType
}
struct HeadedBytes<T> : TypedHeadedBytes {
    
    typealias HeaderType = T
    
    private final class Memory<T> {
        private let size:Int
        let typed:UnsafeMutablePointer<T>
        init(size:Int) {
            self.size = size < MemoryLayout<T>.size ? MemoryLayout<T>.size : size
            typed = UnsafeMutableRawPointer.allocate(bytes: size, alignedTo: MemoryLayout<T>.alignment).bindMemory(to: T.self, capacity: 1)
        }
        
        convenience init(copyFrom other:Memory<T> ) {
            self.init(size: other.size)
            memcpy(typed, other.typed, other.size)
        }
        
        deinit {
            typed.deinitialize().deallocate(bytes: size, alignedTo: MemoryLayout<T>.alignment)
        }
    }
    
    private var memory:Memory<T>
    
    init(size:Int){
        self.memory = Memory<T>(size:size)
    }
    
    @discardableResult mutating func withUnsafeMutablePointer<Result>(_ body:(UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result {
        // copy on write when shared
        if isKnownUniquelyReferenced(&memory) == false {
            memory = Memory<T>(copyFrom:memory)
        }
        return try body(memory.typed)
    }
    
    @discardableResult func withUnsafePointer<Result>(_ body:(UnsafePointer<T>) throws -> Result) rethrows -> Result {
        return try body(memory.typed)
        
    }
}

extension HeadedBytes {
    
    init(numTrailingBytes:Int, initializeWith initialize:(UnsafeMutablePointer<T>)->Void){
        let size = MemoryLayout<T>.size + numTrailingBytes
        self.init(size: size)
        withUnsafeMutablePointer {
            initialize($0)
        }
    }
}
