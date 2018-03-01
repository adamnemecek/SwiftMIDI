//
//  UnsafePointer.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 01.03.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation

extension UnsafePointer {
    var mutable:UnsafeMutablePointer<Pointee> {
        return .init(mutating: self)
    }
    init(fromMutable:UnsafeMutablePointer<Pointee>) {
        self.init(fromMutable)
    }
}
