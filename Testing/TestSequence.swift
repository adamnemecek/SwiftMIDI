//
//  TestSequence.swift
//  MetaEventTests
//
//  Created by Jan Ratschko on 25.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox



class TestSequence {
    enum Error : Swift.Error {
        case loadDataFailed
    }
    
    var sequence:MusicSequence
    
    init?(){
        var newSequence:MusicSequence?
        let status = NewMusicSequence(&newSequence)
        guard status == noErr else {
            return nil
        }
        
        guard let sequence = newSequence else {
            return nil
        }
        
        self.sequence = sequence
    }
    
    convenience init?(data:Data) {
        self.init()
        let status = MusicSequenceFileLoadData(sequence, data as CFData, .midiType, .smf_PreserveTracks)
        if status != noErr {
            return nil
        }
    }
    
    deinit {
        DisposeMusicSequence(sequence)
    }
    
    func newTrack() -> TestTrack? {
        
        var newTrack:MusicTrack?
        let status = MusicSequenceNewTrack(sequence, &newTrack)
        guard status == noErr else {
            return nil
        }
        guard let track =  newTrack else {
            return nil
        }
        
        return TestTrack(track: track)
    }
    
    func firstTrack() -> TestTrack? {
        var firstTrack:MusicTrack?
        let status = MusicSequenceGetIndTrack(sequence, 0, &firstTrack)
        guard status == noErr else {
            return nil
        }
        guard let track =  firstTrack else {
            return nil
        }
        
        return TestTrack(track: track)
    }
    
    func toData() -> Data? {
        var data:Unmanaged<CFData>?
        let status = MusicSequenceFileCreateData(sequence, .midiType, .eraseFile, 480, &data)
        guard status == noErr else {
            data?.release()
            return nil
        }
        if let data = data {
            return data.takeUnretainedValue() as Data
        }
        return nil
    }
}
