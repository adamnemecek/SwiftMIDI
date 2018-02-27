//
//  MIDIPointerExtensions.m
//  SwiftMIDI
//
//  Created by Jan Ratschko on 20.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

#import "MIDIPointerExtensions.h"

// get pointer to const field from a pointer to a const struct, not possible in swift
const MIDIPacket *  _Nonnull MIDIPacketListGetPacket(const MIDIPacketList *  _Nonnull packetList) {
    return packetList->packet;
}

// get pointer to const field from a pointer to a const struct, not possible in swift
const UInt8 * _Nonnull MIDIPacketGetData(const MIDIPacket * _Nonnull packet) {
    return packet->data;
}

// get pointer to const field from a pointer to a const struct, not possible in swift
const UInt8 * _Nonnull MIDIRawDataGetData(const MIDIRawData* _Nonnull  data) {
    return data->data;
}

// get pointer to const field from a pointer to a const struct, not possible in swift
const UInt8 * _Nonnull MusicEventUserDataGetData(const MusicEventUserData* _Nonnull  event) {
    return event->data;
}

// get pointer to const field from a pointer to a const struct, not possible in swift
const UInt8 * _Nonnull MIDIMetaEventGetData(const MIDIMetaEvent* _Nonnull  event){
    return event->data;
}



