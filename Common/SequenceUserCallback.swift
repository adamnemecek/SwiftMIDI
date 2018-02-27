//
//  SequenceUserCallback.swift
//  ReadMIDIPacketList
//
//  Created by Jan Ratschko on 27.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox

protocol UserDataHandler {
    func handleUserDataEvent(sequence:MusicSequence, track:MusicTrack, timeStamp:MusicTimeStamp, userData:UnsafePointer<MusicEventUserData>, startSliceBeat:MusicTimeStamp, endSliceBeat:MusicTimeStamp)
}


struct UserCallback {
    
    let delegate:UserDataHandler
    
    init(delegate:UserDataHandler){
        self.delegate = delegate
    }
    
    let sequencerCallBack : MusicSequenceUserCallback =  {
        (inClientData: UnsafeMutableRawPointer?,
        sequence: MusicSequence,
        track: MusicTrack,
        eventTime: MusicTimeStamp,
        data: UnsafePointer<MusicEventUserData>,
        startSliceBeat: MusicTimeStamp,
        endSliceBeat: MusicTimeStamp) -> Void in
        
        // make shure that the callback will not be called when self was deallocated!!!
        guard let delegate = inClientData?.assumingMemoryBound(to: UserCallback.self).pointee.delegate else {
            return
        }
        delegate.handleUserDataEvent(sequence:sequence,track:track,timeStamp: eventTime, userData:data, startSliceBeat:startSliceBeat, endSliceBeat:endSliceBeat)
    }
    
    mutating func installCallback(to sequence:MusicSequence) -> OSStatus {
        return MusicSequenceSetUserCallback(sequence, sequencerCallBack, &self)
    }
}
