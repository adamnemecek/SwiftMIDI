//
//  main.swift
//  MusicEventUserData
//
//  Created by Jan Ratschko on 27.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//
import Foundation

// demonstates writing and reading of user event data in swift

// set up a test handler for handling user data from MusicSequence callback

struct TestListener : UserDataHandler {
    
    func handleUserDataEvent(sequence: MusicSequence, track: MusicTrack, timeStamp: MusicTimeStamp, userData: UnsafePointer<MusicEventUserData>, startSliceBeat: MusicTimeStamp, endSliceBeat: MusicTimeStamp) {
        
        // get data buffer from UnsafePointer<MusicEventUserData>
        let data = userData.data

        print("called back with bytes: \([UInt8](data))")
        
    }
}

// set up sample data to feed to a MusicEventUserData

let userDataBytes:[UInt8] = [1,2,3,4]
let dataFromBytes = Data(userDataBytes)


// allocate and fill MusicEventUserData
let eventUserData = HeadedBytes<MusicEventUserData>(musicEventUserData:dataFromBytes)


// set up a test sequence for our user data
guard let sequence = TestSequence(),
    let track = sequence.newTrack(),
    let player = TestPlayer() else {
        exit(1)
}

// create a new user data event from our data
eventUserData.withUnsafePointer {
    MusicTrackNewUserEvent(track.track, 0, $0)
}

// set the sequence on our test player
player.setSequence(sequence)


// set up a user callback that eventually will forward data to the delegate
var callback = UserCallback(delegate: TestListener())
guard callback.installCallback(to: sequence.sequence) == noErr else {
    exit(1)
}

// start player
player.start()

// wait while the callback will be called
sleep(1)


