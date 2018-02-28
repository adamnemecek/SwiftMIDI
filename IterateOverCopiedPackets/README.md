#  Iterate over packets in a packet list

Shows why iterating over a packet list using copied packets may result in reading junk data from the packets.

```swift
func iterateOverCopiedPackets(packetList:UnsafePointer<MIDIPacketList>){

    var packet = packetList.pointee.packet

    for i in 0..<packetList.pointee.numPackets {

        // use packet as MIDIPacket


        // the following call copies struct MIDIPacket
        // packet has MemoryLayout<MIDIPacket>.size
        // only 256 bytes of the packet data are copied from the original packetlist

        // from the docs: MIDIPacketNext advances a MIDIPacket pointer to the MIDIPacket that immediately follows a given packet in memory, for packets that are part of a MIDIPacketList array.

        packet =  MIDIPacketNext(&packet).pointee
        // packet now is not any longer part of a MIDIPacketList array
    }
}
```
MIDIPacketNext in c calculates the address of the next packet from the current packet's memory address and the length field.
To use it safely the address of the packet passed to it must be part of the same memory.

In c it would be use like this:

```c

void iterateOverPointedPackets(const MIDIPacketList *packetList) {

    const MIDIPacket *packet = packetList->packet

    for(Int i = 0, i < packetList->numPackets; ++i){

        // use packet as UnsafePointer<MIDIPacket>

        packet = MIDIPacketNext(packet);
    }
}
```
To do this in swift two functions are needed:
1. MIDIPacketListGetPacket
```swift
public func MIDIPacketListGetPacket(_ packetList: UnsafePointer<MIDIPacketList>) -> UnsafePointer<MIDIPacket>
```
Implemeted in c:
```c
// get pointer to const field from a pointer to a const struct, not possible in swift
const MIDIPacket *  _Nonnull MIDIPacketListGetPacket(const MIDIPacketList *  _Nonnull packetList) {
    return packetList->packet;
}
```
2. MIDIPacketGetNextPacket
```swift
public func MIDIPacketGetNextPacket(_ packet: UnsafePointer<MIDIPacket>) -> UnsafePointer<MIDIPacket>
```
Implemeted in c:
```c
// the only diference to MIDIPacketNext is the const specifier of the result
const MIDIPacket * _Nonnull MIDIPacketGetNextPacket(const MIDIPacket * _Nonnull packet) {
    return MIDIPacketNext(packet);
}
```
Now iterating over pointet packets in swift it can be done like this:

```swift
func iterateOverPointedPackets(packetList:UnsafePointer<MIDIPacketList>){

var packet = MIDIPacketListGetPacket(packetList)

for i in 0..<packetList.pointee.numPackets {

// use packet as UnsafePointer<MIDIPacket>

// copies pointer to const MIDIPacket
packet =  MIDIPacketGetNextPacket(packet)
}
}
```
