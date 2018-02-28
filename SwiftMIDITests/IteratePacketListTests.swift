//
//  SwiftMIDITests.swift
//  SwiftMIDITests
//
//  Created by Jan Ratschko on 28.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import XCTest

class IteratePacketListTests: XCTestCase {
    
    func testIterationOverCopiedPackets(){
        var packetList = MutablePacketList(size: 1024)
        var sysex:[UInt8] = [UInt8](repeatElement(0, count: 300))
        sysex[0] = 0xF0     // start sysex
        sysex[299] = 0xF7    // end sysex
        var success = packetList.addPacket(data:Data(sysex), timeStamp:0)
        XCTAssert(success)
        success = packetList.addPacket(data:Data(sysex), timeStamp:0)
        XCTAssert(success)
        
        packetList.withMIDIPacketList { packetList in
            XCTAssert(packetList.pointee.numPackets == 2)
            var packet = packetList.pointee.packet
            
            XCTAssert(packet.timeStamp == 0)
            XCTAssert(packet.length == 300)
            XCTAssert(packet.data.0 == 0xF0 )
            
            // packet may be filled with Junk
            packet =  MIDIPacketNext(&packet).pointee
            
             // these will probably fail
            XCTAssert(packet.timeStamp == 0)
            XCTAssert(packet.length == 300)
            XCTAssert(packet.data.0 == 0xF0 )
        }

    }
    
    func testIterationOverPointedPackets(){
        var packetList = MutablePacketList(size: 1024)
        var sysex:[UInt8] = [UInt8](repeatElement(0, count: 300))
        sysex[0] = 0xF0     // start sysex
        sysex[299] = 0xF7    // end sysex
        var success = packetList.addPacket(data:Data(sysex), timeStamp:0)
        XCTAssert(success)
        success = packetList.addPacket(data:Data(sysex), timeStamp:0)
        XCTAssert(success)
        
        packetList.withMIDIPacketList { packetList in
            XCTAssert(packetList.pointee.numPackets == 2)
            var packet = MIDIPacketListGetPacket(packetList)
            
            XCTAssert(packet.pointee.timeStamp == 0)
            XCTAssert(packet.pointee.length == 300)
            XCTAssert(packet.pointee.data.0 == 0xF0 )
            
            packet =  MIDIPacketGetNextPacket(packet)
            XCTAssert(packet.pointee.timeStamp == 0)
            XCTAssert(packet.pointee.length == 300)
            XCTAssert(packet.pointee.data.0 == 0xF0 )
        }
        
    }
    
}
