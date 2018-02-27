# Iterate over packets in packet list.

```swift

let packtList:[UnsafePoniter<MIDIPacketList>] = ...
    
for packet in packetList.packets {

      // access MIDIPacket fileds like this:
      let length = packet-pointee.length
      let timestamp = packet.pointee.timestamp
      let data:UnsafeBuffrPointer<UInt8> = packet.data
      
}

```

```swift
struct PacketList : Sequence {
    let packetList:UnsafePointer<MIDIPacketList>
    init(_ packetList:UnsafePointer<MIDIPacketList>){
        self.packetList = packetList
    }
    typealias Element = UnsafePointer<MIDIPacket>
    
    func makeIterator() -> AnyIterator<UnsafePointer<MIDIPacket>> {
        
        // access pointer to const packet form const packetList pointer
        // this is done with a c-function, not possible in swift
        var p = MIDIPacketListGetPacket(packetList)
        
        var i = (0..<packetList.pointee.numPackets).makeIterator()
        
        return AnyIterator {
            defer {
                // access pointer to const packet form const packet pointer
                // this is done with a c-function, not possible in swift
                p = MIDIPacketGetNextPacket(p)
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
