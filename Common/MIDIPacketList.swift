//
//  PacketListBuilder.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 26.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation
import CoreMIDI

struct PacketList : Sequence {
    let packetList:UnsafePointer<MIDIPacketList>
    init(_ packetList:UnsafePointer<MIDIPacketList>){
        self.packetList = packetList
    }
    typealias Element = UnsafePointer<MIDIPacket>
    
    func makeIterator() -> AnyIterator<UnsafePointer<MIDIPacket>> {
        
        var p = packetList.packet
        
        var i = (0..<packetList.pointee.numPackets).makeIterator()
        
        return AnyIterator {
            defer {
                p = p.nextPacket()
            }
            return i.next().map { _ in p }
        }
    }
}

extension UnsafePointer where Pointee == MIDIPacketList {
    var packets:PacketList {
        return PacketList(self)
    }
    var packet:UnsafePointer<MIDIPacket> {
        func pointer(_ p:UnsafePointer<MIDIPacket>)->UnsafePointer<MIDIPacket> {
            return p
        }
        return pointer(&UnsafeMutablePointer<MIDIPacketList>(mutating:self).pointee.packet)
    }
}


    


