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

In c it would be used like this:

```c

void iterateOverPointedPackets(const MIDIPacketList *packetList) {

    const MIDIPacket *packet = packetList->packet

    for(Int i = 0, i < packetList->numPackets; ++i){

        // use packet as UnsafePointer<MIDIPacket>

        packet = MIDIPacketNext(packet);
    }
}
```
Iterating over pointet packets in swift it can be done like this:
```swift
extension UnsafePointer {
    var mutable:UnsafeMutablePointer<Pointee> {
        return .init(mutating: self)
    }
    init(fromMutable:UnsafeMutablePointer<Pointee>) {
        self.init(fromMutable)
    }
}
```
```swift
extension UnsafePointer where Pointee == MIDIPacketList {
    var packet:UnsafePointer<MIDIPacket> {
        return .init(fromMutable:&self.mutable.pointee.packet)
    }
}
```
```swift
extension UnsafePointer where Pointee == MIDIPacket {

    var data:UnsafeBufferPointer<UInt8> {
        return .init(start: &self.mutable.pointee.data.0, count:Int(self.pointee.length))
    }
    func nextPacket() -> UnsafePointer<MIDIPacket> {
        return .init(MIDIPacketNext(self))
    }
}
```

```swift
func iterateOverPointedPackets(packetList:UnsafePointer<MIDIPacketList>){

    var packet = packetList.packet

    for i in 0..<packetList.pointee.numPackets {

        // use packet as UnsafePointer<MIDIPacket>

        // copies pointer to const MIDIPacket
        packet =  packet.nextPacket()
    }
}
```
Or with custom Sequence Extension:

```swift
struct PacketList : Sequence {

    typealias Element = UnsafePointer<MIDIPacket>
    
    private let packetList:UnsafePointer<MIDIPacketList>
    
    init(_ packetList:UnsafePointer<MIDIPacketList>){
            self.packetList = packetList
    }
    

    func makeIterator() -> AnyIterator<UnsafePointer<MIDIPacket>> {

            var p = packetList.packet

            var i = (0..<packetList.pointee.numPackets).makeIterator()

            return AnyIterator {
        
            defer {
                p = p.nextPacket()
            }
            return i.next().map { _ in p }
        }
    }
}
```
```swift
extension UnsafePointer where Pointee == MIDIPacketList {
    var packets:PacketList {
        return PacketList(self)
    }
}
```
```swift
func iterateOverPointedPackets(packetList:UnsafePointer<MIDIPacketList>){

    for packet in packetList.packets {

        // use packet as UnsafePointer<MIDIPacket>

    }
}
```
