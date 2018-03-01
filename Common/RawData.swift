//
//  MIDIRawData.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox

extension UnsafePointer where Pointee == MIDIRawData {
    var data:UnsafeBufferPointer<UInt8> {
        return UnsafeBufferPointer<UInt8>(start: &UnsafeMutablePointer<MIDIRawData>(mutating:self).pointee.data, count:Int(self.pointee.length))
    }
}

extension HeadedBytes where HeaderType == MIDIRawData {
    init(midiRawData data: Data) {
        self.init(numTrailingBytes: data.count) { rawData in
            rawData.pointee.length = UInt32(data.count)
            _ = data.withUnsafeBytes { bytes in
                memcpy(&rawData.pointee.data, bytes, data.count)
            }
            
        }
    }
}
