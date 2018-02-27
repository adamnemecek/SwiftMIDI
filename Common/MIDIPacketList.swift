//
//  PacketListBuilder.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 26.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import CoreMIDI

struct PacketList : Sequence {
    let packetList:UnsafePointer<MIDIPacketList>
    init(_ packetList:UnsafePointer<MIDIPacketList>){
        self.packetList = packetList
    }
    typealias Element = UnsafePointer<MIDIPacket>
    func makeIterator() -> AnyIterator<UnsafePointer<MIDIPacket>> {
        
        // access pointer to const packet form const packetList pointer
        // this is done with a c-function, not possible in swift
        var p = MIDIPacketListGetPacket(packetList)
        
        var i = (0..<packetList.pointee.numPackets).makeIterator()
        
        return AnyIterator {
            defer {
                p = MIDIPacketGetNextPacket(p)
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

extension UnsafePointer where Pointee == MIDIPacket {
    var data:UnsafeBufferPointer<UInt8> {
        return UnsafeBufferPointer<UInt8>(start :MIDIPacketGetData(self), count: Int(pointee.length))
    }
}
    

struct MutablePacketList {
    // The maximum size of a packet list is 65536 bytes.
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
            packetSize = Int(MutablePacketList.maxPackageListSize)
        }
        return packetSize
    }
    
    mutating func initialize(){
        currentPacket = packetList.withUnsafeMutablePointer {
            
            // use a c-function here to extend CoreMIDI API
            // the conventional function MIDIPacketListInit does not return an optional
            return PacketListInit($0)
        }
    }
    
    mutating func addPacket(data:Data, timeStamp:MIDITimeStamp) -> Bool {
        currentPacket = packetList.withUnsafeMutablePointer { packetList in
            return data.withUnsafeBytes {
                return PacketListAdd(packetList, size, currentPacket, timeStamp, data.count, $0)
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

