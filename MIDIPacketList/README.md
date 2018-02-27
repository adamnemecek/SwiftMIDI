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
# 2. Allocate packet list and add packets.

```swift
struct MutablePacketList {
    
    // The maximum size of a packet list is 65536 bytes.
    static let maxPackageListSize = 65536
    
    private let size:Int
    private var packetList:HeadedBytes<MIDIPacketList>
    private var currentPacket:UnsafeMutablePointer<MIDIPacket>?
    
    init(size:Int = MemoryLayout<MIDIPacketList>.size) {
        self.size = MutablePacketList.calcSize(size)
        packetList = HeadedBytes(size:self.size)
        initialize()
    }
    
    private static func calcSize(_ size:Int) -> Int {
        var packetSize = MemoryLayout<MIDIPacketList>.size
        
        if size > packetSize {
            packetSize = size
        }
        
        if packetSize > MutablePacketList.maxPackageListSize {
            packetSize = Int(MutablePacketList.maxPackageListSize)
        }
        return packetSize
    }
    
    mutating func initialize(){
        
        currentPacket = packetList.withUnsafeMutablePointer {
            // use a c-function here to extend CoreMIDI API
            // the conventional function MIDIPacketListInit does not return an optional
            return PacketListInit($0)
        }
    }
    
    mutating func addPacket(data:Data, timeStamp:MIDITimeStamp) -> Bool {
        
        currentPacket = packetList.withUnsafeMutablePointer { packetList in
            return data.withUnsafeBytes {
                // use a c-function here to extend CoreMIDI API
                // it returns and takes an optional packet pointer
                // the original function PacketListAdd cannot not be used in this case
                return PacketListAdd(packetList, size, currentPacket, timeStamp, data.count, $0)
            }
        }
        return currentPacket != nil
    }
    
    func withMIDIPacketList<Result>(_ body:(UnsafePointer<MIDIPacketList>) throws -> Result ) rethrows -> Result {
        return try packetList.withUnsafePointer {
            return try body($0)
        }
    }
}
```
