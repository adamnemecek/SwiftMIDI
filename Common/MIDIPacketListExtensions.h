//
//  MIDIPacketListExtensions.h
//  SwiftMIDIAPIExtensions
//
//  Created by Jan Ratschko on 24.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>

/*!
 @function MIDIPacketGetNextPacket
 
 @abstract Advances a const MIDIPacket pointer to the MIDIPacket which immediately follows it in memory if it is part of a MIDIPacketList.
 
* @warning When called with the last packet in the list this function will return a dangling pointer!
 
 @param packet A pointer to a const MIDIPacket in a MIDIPacketList.
 
 @result A pointer to the subsequent const MIDIPacket in the MIDIPacketList. Caution! When called with the last packet in the list the result points to arbitrary memory!
 
 @code var packetList: UnsafePointer<MIDIPacketList> = ...
 
 var packet: UnsafePointer<MIDIPacket> = MIDIPacketListGetPacket(packetList)
 
 for _ in 0..<packetList.pointee.numPackets {
 
    // do something with immutable packet data
 
 
    packet = MIDIPacketGetNextPacket(packet)
 }
 */

inline const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet);

/*!
 @function  MIDIPacketListInit
 
 @abstract  Prepares a MIDIPacketList to be built up dynamically.
 
 @param     packetList
 The packet list to be initialized.
 
 @result A pointer to the first MIDIPacket in the packet list.
 The pointer is marked as nullable.
 
 @code // size of MIDIPacketList (<= UInt16.max)
 let listSize:UInt = ...
 var packetList:UnsafeMutablePointer<MIDIPacketList> = ...
 
 var currentPacket = PacketListInit(packetList)
 
 currentPacket = PacketListAdd(packetList,listSize...
 */
inline
MIDIPacket * _Nullable PacketListInit(MIDIPacketList * _Nonnull packetList);


/**
 @function  PacketListAdd
 
 @abstract Adds a MIDI event to a MIDIPacketList. The maximum size of a packet list is 65536 bytes. Large sysex messages must be sent in smaller packet lists.
 
 @param packetList The mutable packet list to which the event is to be added.
 @param listSize The size, in bytes, of the packet list.
 @param currentPacket A packet pointer returned by a previous call to PacketListInit or PacketListAdd for this packet list. The pointer is marked as nullable. When imported to swift it will be an optional UnsafeMutablePointer.
 @param timeStamp The new event's time.
 @param dataSize The length of the new event, in bytes.
 @param data The new event. May be a single MIDI event, or a partial sys-ex event.  Running status is not permitted.
 
 @discussion The maximum size of a packet list is 65536 bytes. Large sysex messages must be sent in smaller packet lists.
 
 @result Returns null if there was not room in the packet for the event; otherwise returns a packet pointer which should be passed as currentPacket in a subsequent call to this function.
 
 
 @code // size of MIDIPacketList (<= 65536)
 let listSize:UInt = ...
 var packetList:UnsafeMutablePointer<MIDIPacketList> = ...
 
 var currentPacket = PacketListInit(packetList)
 
 currentPacket = PacketListAdd(packetList,listSize...
 */
inline MIDIPacket *_Nullable PacketListAdd(MIDIPacketList * _Nonnull packetList, ByteCount listSize, MIDIPacket *_Nullable currentPacket, MIDITimeStamp timeStamp, ByteCount dataSize, const Byte * _Nonnull data);
