# 1. Iterate over packets in packet list.

MIDI data send to a destination endpoint is delivered as `UnsafePointer<MIDIPacketList>`.
With the extensions listed below, the packets can be retreaved like this:

```swift

let packtList:UnsafePoniter<MIDIPacketList> = ...
    
for packet in packetList.packets {

      // access MIDIPacket fileds like this:
      let length = packet-pointee.length
      let timestamp = packet.pointee.timestamp
      let data:UnsafeBufferPointer<UInt8> = packet.data
      
}

```
Extend `UnsafePointer<MIDIPacketList>` to return a custom `PacketList` struct:

```swift
extension UnsafePointer where Pointee == MIDIPacketList {
    var packets:PacketList {
        return PacketList(self)
    }
}
```
`PacketList` struct is a sequence of `UnsafePointer<MIDIPacket>`:
    
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
extension UnsafePointer where Pointee == MIDIPacket {
    
    var data:UnsafeBufferPointer<UInt8> {
        // access pointer to const UInt8 form const packet pointer
        // this is done with a c-function, MIDIPacketGetData, not possible in swift
        return UnsafeBufferPointer<UInt8>(start:MIDIPacketGetData(self), count:Int(pointee.length))
    }
}
```
