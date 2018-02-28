# SwiftMIDI
### Extensions to CoreMIDI API for swift.

Some simple c-functions to extend the existing CoreMIDI API for swift.

These simple extensions make it possible to do the following three things in swift:

### 1. iterate over packets in a packetlist (packets may be longer than 256 bytes)

See [MIDIPacketList/README.md](MIDIPacketList/README.md#1) and [IterateOverCopiedPackets/README.md](IterateOverCopiedPackets/README.md#1).
  
### 2. add packets to packetLists

See [MIDIPacketList/README.md](MIDIPacketList/README.md#2).
  
### 3. read data out of open ended structs like when pointed to by UnsafePointer<...>
These structs are :`MIDIRawData`, `MIDIMetaEvent`, `MusicEventUserData`. 

See [OpenEndedStructs/main.swift](OpenEndedStructs/main.swift).
  
See [MIDIMetaEvent/main.swift](MIDIMetaEvent/main.swift).
  
See [MIDIRawData/main.swift](MIDIRawData/main.swift).
  
See [MusicEventUserData/main.swift](MusicEventUserData/main.swift).

## C-Functions extending CoreMIDI:

### 1. MIDIPacketGetNextPacket, MIDIPacketListGetPacket

Get an `UnsafePointer<MIDIPacket>` to the first packet from an `UnsaferPointer<MIDIPacketList>`:
```c
inline const MIDIPacket * _Nonnull MIDIPacketListGetPacket(const MIDIPacketList * _Nonnull packetList);
```

Get an `UnsafePointer<MIDIPacket>` to the next packet from an `UnsaferPointer<MIDIPacket>`:
```c
inline const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet);
```

These functions are needed when iterating over the packets in a packetList without copying the packet.
`MIDIPacketNext` from the CoreMIDI API works with pointer-offsets. The next packet must follow the current packet in the same memory block.

See [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of these functions.

### 2. PacketListInit, PacketListAdd
Dynamically build up packet lists in swift.
```c
inline MIDIPacket * _Nullable PacketListInit(MIDIPacketList * _Nonnull packetList);
```

```c
inline MIDIPacket *_Nullable PacketListAdd(MIDIPacketList * _Nonnull packetList, ByteCount listSize, MIDIPacket *_Nullable currentPacket, MIDITimeStamp timeStamp, ByteCount dataSize, const Byte * _Nonnull data);

```


See [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of these functions.

### 3. <...>GetData functions return pointers to data fields from pointers to const structs
- access data fields of `UnsafePointer<MIDIPacket>`, `UnsafePointer<MusicEventUserData>`, `UnsafePointer<MIDIMetaEvent>`, `UnsafePointer<MIDIRawData>` as pointer instead of one-tuple
  
**MIDIPacketGetData** returns a pointer to the data field of MIDIPacket:
```c
inline const UInt8 * _Nonnull MIDIPacketGetData(const MIDIPacket * _Nonnull packet);
```
See [MIDIPacketList.swift](Common/MIDIPacketList.swift) for a use of this function.

**MusicEventUserDataGetData** returns a pointer to the data field of MusicEventUserDataGetData:
```c
inline const UInt8 * _Nonnull MusicEventUserDataGetData(const MusicEventUserData* _Nonnull  event);
```
See [UserEventData.swift](Common/UserEventData.swift) for a use of this function.

**MIDIMetaEventGetData** returns pointer to data field of MIDIMetaEventGetData:
```c
inline const UInt8 * _Nonnull MIDIMetaEventGetData(const MIDIMetaEvent* _Nonnull  event);
```
See [MetaEventData.swift](Common/MetaEventData.swift) for a use of this function.

**MIDIRawDataGetData** returns a pointer to the data field of MIDIRawDataGetData:
```c
inline const UInt8 * _Nonnull MIDIRawDataGetData(const MIDIRawData* _Nonnull  data);
```
See [RawData.swift](Common/RawData.swift) for a use of this function.



 
