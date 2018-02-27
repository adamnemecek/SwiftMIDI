//
//  main.swift
//  MIDIRawData
//
//  Created by Jan Ratschko on 27.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import Foundation

// demonstates writing and reading of sysex data to music sequences

// set up a test sequence for our meta event
guard let sequence = TestSequence(), let track = sequence.newTrack() else {
    exit(1)
}

// set up sysex data

var sysex:[UInt8] = [UInt8](repeatElement(0, count: 300))
sysex[0] = 0xF0     // start sysex
sysex[299] = 0xF7    // end sysex


// allocate and fill MIDIRawData
let rawData = HeadedBytes<MIDIRawData>(midiRawData:Data(sysex))

// add meta event to track
rawData.withUnsafePointer {
    MusicTrackNewMIDIRawDataEvent(track.track, 0, $0)
}

// get first event of track
guard let eventInfo = track.firstEvent else {
    exit(1)
}

// make shure type is right
guard eventInfo.type == kMusicEventType_MIDIRawData else {
    exit(1)
}
//
// cast eventInfo to MIDIMetaEvent
let extractedRawData = eventInfo.data.assumingMemoryBound(to: MIDIRawData.self)

//
// get the data
let data = extractedRawData.data

print("extracted sysex data: \([UInt8](data))")


