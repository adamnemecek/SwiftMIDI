//
//  MetaEventData.swift
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

import AudioToolbox

extension UnsafePointer where Pointee == MIDIMetaEvent {
    var data:UnsafeBufferPointer<UInt8> {
        return .init(start: &self.mutable.pointee.data, count:Int(self.pointee.dataLength))
    }
}

extension HeadedBytes where HeaderType == MIDIMetaEvent {
    init(metaEventType type:UInt8 ,data: Data) {
        self.init(numTrailingBytes: data.count) { metaEvent in
            metaEvent.pointee.metaEventType = type
            metaEvent.pointee.dataLength = UInt32(data.count)
            _ = data.withUnsafeBytes { bytes in
                memcpy(&metaEvent.pointee.data, bytes, data.count)
            }
        }
    }
}
