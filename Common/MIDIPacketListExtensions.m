//
//  MIDIPacketListExtensions.m
//  SwiftMIDI
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

#import "MIDIPacketListExtensions.h"


// the only diference to MIDIPacketNext is the const specifier of the result
const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet) {
    return MIDIPacketNext(packet);
}

// the only diference to MIDIPacketListInit are the nullability specifiers
MIDIPacket * _Nullable PacketListInit(MIDIPacketList * _Nonnull packetList) {
    return MIDIPacketListInit(packetList);
}

// the only diference to MIDIPacketListAdd are the nullability specifiers
MIDIPacket * _Nullable PacketListAdd(MIDIPacketList * _Nonnull packetList, ByteCount listSize, MIDIPacket * _Nullable currentPacket, MIDITimeStamp timeStamp, ByteCount dataSize, const Byte * data) {
    if (currentPacket == nil) {
        return nil;
    }
    return MIDIPacketListAdd(packetList, listSize, currentPacket, timeStamp, dataSize, data);
}
