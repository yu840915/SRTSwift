// The Swift Programming Language
// https://docs.swift.org/swift-book
import SRTInterface

public class SRTSocket {
  let socketID: SRTSOCKET

  init() {
    self.socketID = srt_create_socket()
  }
}
