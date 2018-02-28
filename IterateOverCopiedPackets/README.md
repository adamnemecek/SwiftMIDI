#  Iterate over packets in a packet list

```swift
func iterateOverCopiedPackets(packetList:UnsafePointer<MIDIPacketList>){

    var packet = packetList.pointee.packet

    for i in 0..<packetList.pointee.numPackets {

        // copies struct MIDIPacket
        // packet has MemoryLayout<MIDIPacket>.size
        // only 256 bytes of the packet data are copied from the original packetlist

        // from the docs: MIDIPacketNext advances a MIDIPacket pointer to the MIDIPacket that immediately follows a given packet in memory, for packets that are part of a MIDIPacketList array.

        packet =  MIDIPacketNext(&packet).pointee
        // packet now is not any longer part of a MIDIPacketList array
        
        // use packet as MIDIPacket
    }
}
```

```swift
func iterateOverPointedPackets(packetList:UnsafePointer<MIDIPacketList>){

    var packet = MIDIPacketListGetPacket(packetList)
    
    for i in 0..<packetList.pointee.numPackets {

        // copies pointer to const MIDIPacket
        packet =  MIDIPacketGetNextPacket(packet)
        
        // use packet as UnsafePointer<MIDIPacket>
    }
}
```
