# SwiftMIDI
Extensions to CoreMIDI API for swift.

I wrote some simple c-functions to extend the existing CoreMIDI APi for swift.

These simple extensions make it possible to do the following three things in swift:

- iterate over packets in a packetlist (packets may be longer than 256 bytes)
- add packets to packetLists
- read and write open ended structs like MIDIRawData, MIDIMetaEvent, MusicEventUserData

### MIDIPacketGetNextPacket, MIDIPacketListGetPacket

```c
inline const MIDIPacket * _Nonnull MIDIPacketListGetPacket(const MIDIPacketList * _Nonnull packetList);
```
- get an `UnsafePointer<MIDIPacket>` to the first packet from an `UnsaferPointer<MIDIPacketList>`
```c
inline const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet);
```
- get an `UnsafePointer<MIDIPacket>` to the next packet from an `UnsaferPointer<MIDIPacket>`

These functions are needed when iterating over the packets in a packetList without copying the packet.
MIDIPacketNext from the CoreMIDI API works with pointer-offsets. The next packet must follow the current packet in the same memory block.

see [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of these functions]

### PacketListInit, PacketListAdd

```c
inline MIDIPacket * _Nullable PacketListInit(MIDIPacketList * _Nonnull packetList);
```

```c
inline MIDIPacket *_Nullable PacketListAdd(MIDIPacketList * _Nonnull packetList, ByteCount listSize, MIDIPacket *_Nullable currentPacket, MIDITimeStamp timeStamp, ByteCount dataSize, const Byte * _Nonnull data);

```
- dynamically build up packet lists in swift

see [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of these functions

### MIDIPacketGetData

```c
inline const UInt8 * _Nonnull MIDIPacketGetData(const MIDIPacket * _Nonnull packet);
```
- access data field of MIDIPacket struct as `UnsafePointer<UInt8>` from an `UnsafePointer<MIDIPacket>`
see [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of this function

 
