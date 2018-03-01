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
    
     typealias Element = UnsafePointer<MIDIPacket>
    
    private let packetList:UnsafePointer<MIDIPacketList>
    
    init(_ packetList:UnsafePointer<MIDIPacketList>){
        self.packetList = packetList
    }
       
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
}

extension UnsafePointer where Pointee == MIDIPacketList {
    var packet:UnsafePointer<MIDIPacket> {
        return .init(fromMutable:&self.mutable.pointee.packet)
    }
}


    


