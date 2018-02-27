//
//  SimpleMIDIClient.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 25.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import CoreMIDI


class TestMIDIClient {
    static let sharedInstance = TestMIDIClient()
    let client:MIDIClientRef
    var outputPort:MIDIPortRef
    private init(){
        var client = MIDIClientRef()
        MIDIClientCreateWithBlock("SimpleMIDIClient" as CFString, &client) { notification in
            
        }
        self.client = client
        var outputPort = MIDIPortRef()
        MIDIOutputPortCreate(client, "SimpleMIDIClientOutput" as CFString, &outputPort)
        self.outputPort = outputPort
    }
    
    deinit {
        MIDIClientDispose(client)
    }
    
    func send(_ packetList:UnsafePointer<MIDIPacketList>, to destination:MIDIEndpointRef){
        MIDISend(outputPort, destination, packetList)
    }
}
