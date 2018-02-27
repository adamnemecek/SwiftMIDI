//
//  main.swift
//  MIDIMetaEvent
//
//  Created by Jan Ratschko on 27.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//
import Foundation

// demonstates writing and reading of meta events in swift

// set up a test sequence for our meta event
guard let sequence = TestSequence(), let track = sequence.newTrack() else {
    exit(1)
}

// set up trackName data as ascii string bytes

let trackName = "this track is named 'untitled track'"
guard let trackNameData = trackName.data(using: String.Encoding.ascii) else {
    exit(1)
}

let eventType:UInt8 = 3 // track name

// allocate and fill MIDIMetaData
let metaEvent = HeadedBytes<MIDIMetaEvent>(metaEventType:eventType, data:trackNameData)

// add meta event to track
metaEvent.withUnsafePointer {
    MusicTrackNewMetaEvent(track.track, 0, $0)
}

// get first event of track
guard let eventInfo = track.firstEvent else {
    exit(1)
}

// make shure type is right
guard eventInfo.type == kMusicEventType_Meta else {
    exit(1)
}

// cast eventInfo to MIDIMetaEvent
let extractedMeta = eventInfo.data.assumingMemoryBound(to: MIDIMetaEvent.self)

// make shure type is right
guard extractedMeta.pointee.metaEventType == 3 else {
    exit(1)
}

// get the data
let data = extractedMeta.data

// extract ascii string from bytes
guard let extractedTrackname = String(bytes:data, encoding:String.Encoding.ascii) else {
    exit(1)
}

print("extracted track name: \(extractedTrackname)")
