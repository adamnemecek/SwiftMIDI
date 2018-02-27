//
//  TestEndpoint.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 25.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import CoreMIDI

class TestDestination {
    let endpoint:MIDIEndpointRef
    init?(name:String, handler: @escaping (UnsafePointer<MIDIPacketList>)->Void){
        var endpoint = MIDIEndpointRef()
        var status = MIDIDestinationCreateWithBlock(TestMIDIClient.sharedInstance.client, name as CFString, &endpoint) { (packetList, _) in
            handler(packetList)
        }
        if status != noErr {
            return nil
        }
        self.endpoint = endpoint
        
        // make this virtual destination privet
        status = MIDIObjectSetIntegerProperty(endpoint, kMIDIPropertyPrivate, 1)
        
        if status != noErr {
            MIDIEndpointDispose(endpoint)
            return nil
        }
    }
    deinit {
        MIDIEndpointDispose(endpoint)
    }
}
