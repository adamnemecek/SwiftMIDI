//
//  TestTrack.swift
//  MetaEventTests
//
//  Created by Jan Ratschko on 25.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox


struct TestTrack {
    let track:MusicTrack
    init(track:MusicTrack){
       self.track = track
    }
    
    var firstEvent: (type:MusicEventType, timeStamp:MusicTimeStamp, data:UnsafeRawPointer)? {
        var newIterator:MusicEventIterator?
        var status = NewMusicEventIterator(track, &newIterator)
        
        guard status == noErr else {
            return nil
        }
        
        guard let iterator = newIterator else {
            return nil
        }
        
        var timeStamp:MusicTimeStamp = 0
        var eventType:MusicEventType = kMusicEventType_NULL
        var eventData:UnsafeRawPointer?
        var eventDataSize:UInt32 = 0
        
        status = MusicEventIteratorGetEventInfo(iterator, &timeStamp, &eventType, &eventData, &eventDataSize)
        guard status == noErr else {
            return nil
        }
        
        guard let data = eventData else {
            return nil
        }
        return (type:eventType,timeStamp:timeStamp,data:data)
    }
}
