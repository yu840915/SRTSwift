import SRTInterface

extension SRTSocket {
  public enum Status: UInt32, CustomStringConvertible, Sendable {
    case setUp = 1  // SRTS_INIT
    case opened
    case listening
    case connecting
    case connected
    case broken
    case closing
    case closed
    case nonExist

    public var description: String {
      switch self {
      case .setUp: "init"
      case .opened: "opened"
      case .listening: "listening"
      case .connecting: "connecting"
      case .connected: "connected"
      case .broken: "broken"
      case .closing: "closing"
      case .closed: "closed"
      case .nonExist: "nonExist"
      }
    }

    var nativeValue: SRT_SOCKSTATUS {
      SRT_SOCKSTATUS(rawValue: self.rawValue)
    }

    init(nativeValue: SRT_SOCKSTATUS) {
      guard
        let status = Status(rawValue: nativeValue.rawValue)
      else {
        fatalError("Unknown SRT socket status: \(nativeValue.rawValue)")
      }
      self = status
    }
  }
}
