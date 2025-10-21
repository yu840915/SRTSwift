public struct SRTStreamID: Sendable, CustomStringConvertible {
  public var userName: String?
  public var resourceName: String?
  public var hostName: String?
  public var sessionID: String?
  public var type: Type?
  public var mode: Mode?

  public var description: String {
    stringValue
  }

  var stringValue: String {
    var components: [String] = []
    if let userName {
      components.append("u=\(userName)")
    }
    if let resourceName {
      components.append("r=\(resourceName)")
    }
    if let hostName {
      components.append("h=\(hostName)")
    }
    if let sessionID {
      components.append("s=\(sessionID)")
    }
    if let type {
      components.append("t=\(type.rawValue)")
    }
    if let mode {
      components.append("m=\(mode.rawValue)")
    }
    return "#!::" + components.joined(separator: ",")
  }

  public init(_ builder: SRTOptionBuilder<SRTStreamID>? = nil) {
    builder?(&self)
  }
}

extension SRTStreamID {
  public enum `Type`: String, Sendable {
    case stream
    case file
    case auth

  }

  public enum Mode: String, Sendable {
    case request
    case publish
    case bidirectional
  }
}
