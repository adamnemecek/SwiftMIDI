//
//  MIDIStructHelper.h
//  ExploreMusicUserEvent
//
//  Created by Jan Ratschko on 20.02.18.
//  Copyright © 2018 Jan Ratschko. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <AudioToolbox/AudioToolbox.h>


/*!
 @function MIDIPacketListGetPacket
 
 @abstract Access the first packet in a const MIDIPacket struct.
 
 @discussion The returned data is immutable. When imported to swift is can be used to assign an UnsafePointer<MIDIPacket> from an UnsafePointer<MIDIPacketList> to start iterating over the packets in the list.
 
 @result A pointer an array of MIDI bytes.
 
 @code let packetList: UnsafePointer<MIDIPacketList> = ...
 
 var packet = MIDIPacketListGetPacket(packetList)
 
 for _ in 0..<packetList.pointee.numPackets {
 
    // do something with immutable MIDIPacket data
 
    packet = MIDIPacketGetNextPacket(packet)
 }
 */

inline const MIDIPacket * _Nonnull MIDIPacketListGetPacket(const MIDIPacketList * _Nonnull packetList);

/*!
 @function MIDIPacketGetData
 
 @abstract Access data in a const MIDIPacket struct.
 
 The MIDI messages in the packet must always be complete, except for system-exclusive. The returned data is immutable. When imported to swift is can be used to create an UnsafeBufferPointer<UInt8> from const MIDIPacket data.
 
 @result A pointer to an array of MIDI bytes.
 
 @code let packet: UnsafePointer<MIDIPacket> = ...
 let data = UnsafeBufferPointer<UInt8>(
        start:  MIDIPacketGetData(packet),
        count:  Int(packet.pointee.length))
*/

inline const UInt8 * _Nonnull MIDIPacketGetData(const MIDIPacket * _Nonnull packet);



/*!
 @function MIDIRawDataGetData
 
 @abstract  Access data in a const MIDIRawData struct.
 When imported to swift it can be used to create an UnsafeBufferPointer<UInt8> from const MIDIRawData data.
 
 @param data A pointer to a const MIDIRawData struct.
 
 @result A pointer to an array of sysex bytes.
 
 @code let rawData: UnsafePointer<MIDIRawData> = ...
 
 let data = UnsafeBufferPointer<UInt8>(
                start:  MIDIRawDataGetData(rawData),
                count:  Int(rawData.pointee.length))
 */
inline const UInt8 * _Nonnull MIDIRawDataGetData(const MIDIRawData* _Nonnull  data);

/*!
 @function MusicEventUserDataGetData
 
 @abstract  Access data in a const MusicEventUserData struct.
 When imported to swift it can be used to create an UnsafeBufferPointer<UInt8> from const MusicEventUserData data.
 
 @param event A pointer to a const MusicEventUserData struct.
 
 @result A pointer to an array of user data bytes.
 
 @code let userData: UnsafePointer<MusicEventUserData> = ...
 
 let data = UnsafeBufferPointer<UInt8>(
                start:  MusicEventUserDataGetData(userData),
                count:  Int(packet.pointee.length))
 */
inline const UInt8 * _Nonnull MusicEventUserDataGetData(const MusicEventUserData* _Nonnull  event);

/*!
 @function MIDIMetaEventGetData
 
 @abstract  Access data in a const MIDIMetaEvent struct.
 When imported to swift it can be used to create an UnsafeBufferPointer<UInt8> from const MIDIMetaEvent data.
 
 @param event A pointer to a const MIDIMetaEvent struct.
 
 @result A pointer to an array of user data bytes.
 
 @code let event: UnsafePointer<MIDIMetaEvent> = ...
 
 let data = UnsafeBufferPointer<UInt8>(
                start:  MIDIMetaEventGetData(event),
                count:  Int(event.pointee.dataLength))
 */
inline const UInt8 * _Nonnull MIDIMetaEventGetData(const MIDIMetaEvent* _Nonnull  event);



