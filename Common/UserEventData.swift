//
//  UserEventData.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox

extension UnsafePointer where Pointee == MusicEventUserData {
    var data:UnsafeBufferPointer<UInt8> {
        
        // access pointer to const UInt8 form const packet pointer
        // this is done with a c-function, MusicEventUserDataGetData, not possible in swift
        return UnsafeBufferPointer<UInt8>(start:MusicEventUserDataGetData(self), count:Int(self.pointee.length))
    }
}

extension HeadedBytes where HeaderType == MusicEventUserData {
    init(musicEventUserData data: Data) {
        self.init(numTrailingBytes: data.count) { userData in
            userData.pointee.length = UInt32(data.count)
            
            _ = data.withUnsafeBytes { bytes in
                memcpy(&userData.pointee.data, bytes, data.count)
            }
        }
    }
}
