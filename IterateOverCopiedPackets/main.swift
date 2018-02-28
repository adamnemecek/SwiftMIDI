//
//  main.swift
//  IterateOverCopiedPackets
//
//  Created by Jan Ratschko on 28.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation

// demonstrates iterating over packets in packet list in two different ways
// 1. by copying a the next packet to a MIDIPacket struct -> this will procuce junk data!
// 2. by copying a pointer to the next packet to a pointer

func sysexString<S>(bytes:S) -> String where S :Sequence, S.Element == UInt8 {
    let bytesString = bytes.reduce("", {
        switch $1 {
        case 0:
            return $0 + "."
        case 0xF0:
            return $0 + "start"
        case 0xF7:
            return $0 + "end"
        default:
            return $0 + "?"
        }
    })
    return bytesString
}

func printPacket(packet: UnsafePointer<MIDIPacket>, index:UInt32){
    print("packet \(index + 1) with timeStamp: \(packet.pointee.timeStamp), length: \(packet.pointee.length):\n")
    
    let bytes = UnsafeBufferPointer<UInt8>(start:MIDIPacketGetData(packet), count:Int(packet.pointee.length))
    print("\(sysexString(bytes: bytes))\n")
}


func iterateOverCopiedPackets(packetList:UnsafePointer<MIDIPacketList>){
    
    var packet = packetList.pointee.packet
    
    for i in 0..<packetList.pointee.numPackets {
        
        printPacket(packet: &packet, index:i)
        
        // copies struct MIDIPacket
        // packet has MemoryLayout<MIDIPacket>.size
        // only 256 bytes of the packet data are copied from the original packetlist
        
        // from the docs: MIDIPacketNext advances a MIDIPacket pointer to the MIDIPacket that immediately follows a given packet in memory, for packets that are part of a MIDIPacketList array.
        
        packet =  MIDIPacketNext(&packet).pointee
        // packet now is not any longer part of a MIDIPacketList array
    }
}

func iterateOverPointedPackets(packetList:UnsafePointer<MIDIPacketList>){
    
    var packet = MIDIPacketListGetPacket(packetList)
    for i in 0..<packetList.pointee.numPackets {
        
        printPacket(packet: packet, index:i)
        
        // copies pointer to const MIDIPacket
        packet =  MIDIPacketGetNextPacket(packet)
    }
}

// the packet list will be initialized by a call to MIDIPacketListInit, see MIDIPacketList.swift
var packetList = MutablePacketList(size: 1024)

var sysex:[UInt8] = [UInt8](repeatElement(0, count: 300))
sysex[0] = 0xF0     // start sysex
sysex[299] = 0xF7    // end sysex

// the packet data will be added by a call to MIDIPacketList add, see MIDIPacketList.swift
var success = packetList.addPacket(data:Data(sysex), timeStamp:0) // timeStamp 0 for testing
assert(success)
success = packetList.addPacket(data:Data(sysex), timeStamp:1) // timeStamp 1 for testing
assert(success)

packetList.withMIDIPacketList { packetList in
    
    print("iterateCopiedPackets:\n")
    print("(packet may contain no bytes at all or sysex with questionable data '?' and no end)\n")
    iterateOverCopiedPackets(packetList: packetList)
    print("\niteratePointedPackets:\n")
    iterateOverPointedPackets(packetList: packetList)
    
}





