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
In swift it can be used like this:

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
