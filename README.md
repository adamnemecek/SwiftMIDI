# SwiftMIDI
Extensions to CoreMIDI API for swift.

I wrote some simple c-functions to extend the existing CoreMIDI APi for swift.

These simple extensions make it possible to do the following three things in swift:

- iterate over packets in a packetlist (packets may be longer than 256 bytes)
- add packets to packetLists
- read and write open ended structs like MIDIRawData, MIDIMetaEvent, MusicEventUserData

```c
inline const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet);
```

```c
inline MIDIPacket * _Nullable PacketListInit(MIDIPacketList * _Nonnull packetList);
```
```c
inline MIDIPacket *_Nullable PacketListAdd(MIDIPacketList * _Nonnull packetList, ByteCount listSize, MIDIPacket *_Nullable currentPacket, MIDITimeStamp timeStamp, ByteCount dataSize, const Byte * _Nonnull data);

```

 
