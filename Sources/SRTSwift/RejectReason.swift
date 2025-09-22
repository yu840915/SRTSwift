import SRTInterface

enum RejectReason: UInt32, CustomStringConvertible {
  case unknown = 0
  case system
  case peer
  case resource
  case rogue
  case backlog
  case internalProgramError
  case close
  case version
  case rendezvousCookieCollision
  case badSecret
  case unsecure
  case messageAPICollision
  case congestion
  case filter
  case group
  case timeout
  case crypto
  case size

  var description: String {
    switch self {
    case .unknown: "unknown"
    case .system: "system"
    case .peer: "peer"
    case .resource: "resource"
    case .rogue: "rogue"
    case .backlog: "backlog"
    case .internalProgramError: "internalProgramError"
    case .close: "close"
    case .version: "version"
    case .rendezvousCookieCollision: "rendezvousCookieCollision"
    case .badSecret: "badSecret"
    case .unsecure: "unsecure"
    case .messageAPICollision: "messageAPICollision"
    case .congestion: "congestion"
    case .filter: "filter"
    case .group: "group"
    case .timeout: "timeout"
    case .crypto: "crypto"
    case .size: "size"
    }
  }

  init(nativeValue: SRT_REJECT_REASON) {
    guard
      let reason = RejectReason(rawValue: nativeValue.rawValue)
    else {
      fatalError("Unknown SRT reject reason: \(nativeValue.rawValue)")
    }
    self = reason
  }
}
