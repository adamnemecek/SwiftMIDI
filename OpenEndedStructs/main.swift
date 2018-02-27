//
//  main.swift
//  TypedData
//
//  Created by Jan Ratschko on 26.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation

// demonstrates the use of 'open-ended' CoreMIDI structs in swift
// MIDIRawData, MIDIMetaEvent, MusicEventUserData


// 1. MIDIRawData

let bytes:[UInt8] = [1,2,3,4]

let data = Data(bytes).base64EncodedData()
let rawData = HeadedBytes<MIDIRawData>(midiRawData: data)

// access raw data from an UnsafePointer<MIDIRawData>
rawData.withUnsafePointer {
    guard let data = Data(base64Encoded: Data($0.data)) else {
        return
    }
    let bytes = [UInt8](data)
    print("bytes: \(bytes)")
}


// 2. MIDIMetaEvent

let trackName = "untitled"

let trackNameData = trackName.data(using: String.Encoding.ascii)!

let metaEvent = HeadedBytes<MIDIMetaEvent>(metaEventType:3, data:trackNameData)

// access raw data from an UnsafePointer<MIDIMetaEvent>
metaEvent.withUnsafePointer {
    guard let trackName = String(bytes:$0.data, encoding:String.Encoding.ascii) else {
        return
    }
    print("trackName: \(trackName)")
}


// 3. MusicEventUserData

let userDataBytes:[UInt8] = [5,6,7,8]
let dataFromBytes = Data(userDataBytes)

let eventUserData = HeadedBytes<MusicEventUserData>(musicEventUserData:dataFromBytes)

// access raw data from an UnsafePointer<MusicEventUserData>
eventUserData.withUnsafePointer {
    let bytes = [UInt8]($0.data)
    print("bytes: \(bytes)")
}




