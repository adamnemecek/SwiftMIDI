//
//  MIDIPacket.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 01.03.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacket {
    
    var data:UnsafeBufferPointer<UInt8> {
        return .init(start: &self.mutable.pointee.data.0, count:Int(self.pointee.length))
    }
    func nextPacket() -> UnsafePointer<MIDIPacket> {
        return .init(MIDIPacketNext(self))
    }
}
