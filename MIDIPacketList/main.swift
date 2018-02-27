//
//  main.swift
//  MIDIPacketList
//
//  Created by Jan Ratschko on 26.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation


// demonstrates how to add packets to a dynamically allocated packetList in swift
// demonstrates iterating over the packets of a const packetList pointed to by UnsafePointer<MIDIPacketList>
// packetList may eventually be 65536 bytes long, when dynamically allocated
// packets may be longer than 256 bytes


// set up a destination for testing
let newDestination = TestDestination(name: "test") { packetList in
    
    print("received packetlist, num packets:\(packetList.pointee.numPackets)")
    
    for packet in packetList.packets {
        print("\nreceived packet with timestamp \(packet.pointee.timeStamp), length: \(packet.pointee.length)")
        print("\([UInt8](packet.data))")
    }
}

guard let destination = newDestination else {
    exit(1)
}

// cerate a packetlist
var packetList = MutablePacketList(size: 1024)

var success = false

// fill list with packets until full
while true {

    var data = Data()
    
    let noteOn:[UInt8] = [0x90,60,100]
    
    for _ in 0..<5 {
        data.append(contentsOf:noteOn) // append some note on messages to packet data
    }
    
    // append packet of note-on messages to packetList
    success = packetList.addPacket(data: data, timeStamp: 0)
    
    guard success else {
        break
    }
    
    // make this longer than 256 bytes to demonstrate reading longer packets
    var sysex:[UInt8] = [UInt8](repeatElement(0, count: 300))
    sysex[0] = 0xF0     // start sysex
    sysex[299] = 0xF7    // end sysex
    
    // append packet with sysex data to packetList
    success = packetList.addPacket(data: Data(sysex), timeStamp: 0)
    
    guard success else {
        break
    }
    
}

// send packetList to destination
packetList.withMIDIPacketList {
    print("send packetList, num packets: \($0.pointee.numPackets)")
    TestMIDIClient.sharedInstance.send($0, to: destination.endpoint)
}

// wait for some output
sleep(1)

