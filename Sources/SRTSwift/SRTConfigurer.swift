import Foundation
import SRTInterface

class SRTConfigurer {
  let socketID: SRTSOCKET

  init(socketID: SRTSOCKET) {
    self.socketID = socketID
  }

  func setPreBindOptions(_ options: SRTOptions.PreBindOptions) throws {
    if let op = options.bindToDevice {
      try setOption(name: SRTO_BINDTODEVICE, value: op)
    }
    if let op = options.typeOfServiceOfIP, Range(0...255).contains(op) {
      guard Range(0...255).contains(op) else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_IPTOS, value: Int32(op))
    }
    if let op = options.IPTTL {
      try setOption(name: SRTO_IPTTL, value: Int32(op))
    }
    if let op = options.IPFamilyOption {
      try setOption(name: SRTO_IPV6ONLY, value: Int32(op.rawValue))
    }
    if let op = options.maxSegmentSize {
      guard op >= 76 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_MSS, value: Int32(op))
    }
    if let op = options.receiveBufferSize {
      try setOption(name: SRTO_RCVBUF, value: Int32(op))
    }
    if let op = options.reusingAddress {
      try setOption(name: SRTO_REUSEADDR, value: op)
    }
    if let op = options.sendBufferSize {
      try setOption(name: SRTO_SNDBUF, value: Int32(op))
    }
    if let op = options.UDPReceiveBufferSize {
      try setOption(name: SRTO_UDP_RCVBUF, value: Int32(op))
    }
    if let op = options.UDPSendBufferSize {
      try setOption(name: SRTO_UDP_SNDBUF, value: Int32(op))
    }
  }

  func setPreOptions(_ options: SRTOptions.PreOptions) throws {
    if let op = options.congestion {
      try setOption(name: SRTO_CONGESTION, value: op.rawValue)
    }
    if let op = options.connectionTimeout {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_CONNTIMEO, value: Int32(ms))
    }
    if let op = options.isEncryptionEnforced {
      try setOption(name: SRTO_ENFORCEDENCRYPTION, value: op)
    }
    if let op = options.maxPacketsInFlight {
      guard op >= 32 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_FC, value: Int32(op))
    }
    if let op = options.acceptsGroupConnections {
      try setOption(name: SRTO_GROUPCONNECT, value: op ? Int32(1) : Int32(0))
    }
    if let op = options.streamEncryptingKeyInterval {
      guard op >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_KMPREANNOUNCE, value: Int32(op))
    }
    if let op = options.streamEncryptingKeyRefreshRate {
      guard op >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_KMREFRESHRATE, value: Int32(op))
    }
    if let op = options.latency {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_LATENCY, value: Int32(ms))
    }
    if let op = options.usingMessageAPI {
      try setOption(name: SRTO_MESSAGEAPI, value: op)
    }
    if let op = options.minPeerVersion {
      try setOption(name: SRTO_MINVERSION, value: Int32(op))
    }
    if let op = options.reportsNAK {
      try setOption(name: SRTO_NAKREPORT, value: op)
    }
    if let op = options.packetFilter {
      guard op.count <= 512 else {
        throw Error.argumentTooLarge
      }
      try setOption(name: SRTO_PACKETFILTER, value: op)
    }
    if let op = options.passphrase {
      guard Range(10...80).contains(op.count) else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_PASSPHRASE, value: op)
    }
    if let op = options.payloadSize {
      guard op > 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_PAYLOADSIZE, value: Int32(op))
    }
    if let op = options.keyLength {
      guard [16, 24, 32].contains(op) else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_PBKEYLEN, value: Int32(op))
    }
    if let op = options.peerIdleTimeout {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_PEERIDLETIMEO, value: Int32(ms))
    }
    if let op = options.peerLatency {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_PEERLATENCY, value: Int32(ms))
    }
    if let op = options.receiveLatency {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_RCVLATENCY, value: Int32(ms))
    }
    if let op = options.usingRendezvous {
      try setOption(name: SRTO_RENDEZVOUS, value: op)
    }
    if let op = options.retransmissionAlgorithm {
      try setOption(name: SRTO_RETRANSMITALGO, value: Int32(op.rawValue))
    }
    if let op = options.streamID?.stringValue {
      guard op.count <= 512 else {
        throw Error.argumentTooLarge
      }
      try setOption(name: SRTO_STREAMID, value: op)
    }
    if let op = options.shouldDropTooLatePacket {
      try setOption(name: SRTO_TLPKTDROP, value: op)
    }
    if let op = options.transmissionType {
      try setOption(name: SRTO_TRANSTYPE, value: Int32(op.rawValue))
    }
    if let op = options.usingTimestampBasedPacketDeliveryMode {
      try setOption(name: SRTO_TSBPDMODE, value: op)
    }
  }

  func setPostOptions(_ options: SRTOptions.PostOptions) throws {
    if let op = options.isDriftTracerEnabled {
      try setOption(name: SRTO_DRIFTTRACER, value: op)
    }
    if let op = options.inputBandwidth {
      guard op >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_INPUTBW, value: Int64(op))
    }
    if let op = options.linger {
      let s = op.seconds
      guard s >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_LINGER, value: Int32(s))
    }
    if let op = options.maxLossTTL {
      let ms = op.milliseconds
      guard ms >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_LOSSMAXTTL, value: Int32(ms))
    }
    if let op = options.maxBandwidth {
      let val: Int64 =
        switch op {
        case .infinite: -1
        case .relativeToInputRate: 0
        case .absolute(let v): Int64(v)
        }
      guard val >= -1 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_MAXBW, value: val)
    }
    if let op = options.minInputBandwidth {
      guard op >= 0 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_MININPUTBW, value: Int64(op))
    }
    if let op = options.recoveryOverheadPercentage {
      guard Range(5...100).contains(op) else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_OHEADBW, value: Int32(op))
    }
    if let op = options.isReadingBlocking {
      try setOption(name: SRTO_RCVSYN, value: op)
    }
    if let op = options.receiveTimeout {
      let ms = op.milliseconds
      guard ms >= -1 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_RCVTIMEO, value: Int32(ms))
    }
    if let op = options.sendDropDelay {
      let ms = op.milliseconds
      guard ms >= -1 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_SNDDROPDELAY, value: Int32(ms))
    }
    if let op = options.isSendingBlocking {
      try setOption(name: SRTO_SNDSYN, value: op)
    }
    if let op = options.sendTimeout {
      let ms = op.milliseconds
      guard ms >= -1 else {
        throw Error.argumentOutOfRange
      }
      try setOption(name: SRTO_SNDTIMEO, value: Int32(ms))
    }
  }

  private func setOption(name: SRT_SOCKOPT, value: String) throws {
    guard let data = value.data(using: .utf8) else {
      throw Error.cannotEncodeArgument
    }
    guard data.count < 512 else {
      throw Error.argumentTooLarge
    }
    try setOption(name: name, data: data)
  }

  func setOption(name: SRT_SOCKOPT, value: Int32) throws {
    var value = value
    let data = Data(bytes: &value, count: MemoryLayout<Int32>.size)
    try setOption(name: name, data: data)
  }

  func setOption(name: SRT_SOCKOPT, value: Int64) throws {
    var value = value
    let data = Data(bytes: &value, count: MemoryLayout<Int64>.size)
    try setOption(name: name, data: data)
  }

  func setOption(name: SRT_SOCKOPT, value: Bool) throws {
    var value = value
    let data = Data(bytes: &value, count: MemoryLayout<Bool>.size)
    try setOption(name: name, data: data)
  }

  func setOption(name: SRT_SOCKOPT, data: Data) throws {
    let result = data.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) in
      srt_setsockflag(socketID, name, rawBufferPointer.baseAddress, Int32(data.count))
    }
    try checkResult(result)
  }
}
