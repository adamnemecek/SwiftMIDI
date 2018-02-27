# SwiftMIDI
Extensions to CoreMIDI API for swift.

I wrote some simple c-functions to extend the existing CoreMIDI APi for swift.

These simple extensions make it possible to do the following three things in swift:

- iterate over packets in a packetlist (packets may be longer than 256 bytes)
- add packets to packetLists
- read and write open ended structs like MIDIRawData, MIDIMetaEvent, MusicEventUserData


