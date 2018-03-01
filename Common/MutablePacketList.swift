//
//  MutablePacketList.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 01.03.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation
import CoreMIDI

struct MutablePacketList {
    
    // The maximum size of a packet list is 65536 bytes (UInt16.max + 1).
    static let maxPackageListSize = 65536
    
    private let size:Int
    private var packetList:HeadedBytes<MIDIPacketList>
    private var currentPacket:UnsafeMutablePointer<MIDIPacket>?
    
    init(size:Int = MemoryLayout<MIDIPacketList>.size) {
        self.size = MutablePacketList.calcSize(size)
        packetList = HeadedBytes(size:self.size)
        initialize()
    }
    
    private static func calcSize(_ size:Int) -> Int {
        var packetSize = MemoryLayout<MIDIPacketList>.size
        
        if size > packetSize {
            packetSize = size
        }
        
        if packetSize > MutablePacketList.maxPackageListSize {
            packetSize = MutablePacketList.maxPackageListSize
        }
        return packetSize
    }
    
    mutating func initialize(){
        currentPacket = packetList.withUnsafeMutablePointer {
            return MIDIPacketListInit($0)
        }
    }
    
    func PacketListAdd(packetList: UnsafeMutablePointer<MIDIPacketList>, size: Int, currentPacket: UnsafeMutablePointer<MIDIPacket>?, timeStamp: MIDITimeStamp, dataSize: Int, data: UnsafePointer<UInt8>) -> UnsafeMutablePointer<MIDIPacket>? {
        
        guard let currentPacket = currentPacket else {
            return nil
        }
        // MIDIPacketListAdd may return nil but is not imported as an optional pointer
        return MIDIPacketListAdd(packetList, size, currentPacket, timeStamp, dataSize, data)
    }
    
    mutating func addPacket(data:Data, timeStamp:MIDITimeStamp) -> Bool {
        
        currentPacket = packetList.withUnsafeMutablePointer { packetList in
            return data.withUnsafeBytes {
                
                return PacketListAdd(packetList:packetList, size:size, currentPacket:currentPacket, timeStamp:timeStamp, dataSize:data.count, data:$0)
            }
        }
        return currentPacket != nil
    }
    
    func withMIDIPacketList<Result>(_ body:(UnsafePointer<MIDIPacketList>) throws -> Result ) rethrows -> Result {
        return try packetList.withUnsafePointer {
            return try body($0)
        }
    }
}
