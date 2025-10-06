import SRTInterface

public typealias SRTResult = Result<Void, Error>

extension SRTResult: @retroactive CustomStringConvertible {
  public init(nativeValue: SRT_ERRNO) {
    switch nativeValue {
    case SRT_SUCCESS:
      self = .success(())
    default:
      self = .failure(Error(nativeValue: nativeValue))
    }
  }

  public var description: String {
    switch self {
    case .success: "success"
    case let .failure(error): "failure: \(error)"
    }
  }
}

public enum Error: Swift.Error, CustomStringConvertible, Equatable {
  case unknown

  case invalidEndpoint

  case setUp
  case noServer
  case rejected
  case socketFailed
  case securityIssue
  case closed

  case connection
  case connectionLost
  case noConnection

  case systemResource
  case noThread
  case noMemory
  case noObject

  case fileSystem
  case invalidFileReadOffset
  case noFileReadPermission
  case invalidFileWriteOffset
  case noFileWritePermission

  case notSupported
  case socketAlreadyBound
  case socketAlreadyConnected
  case invalidArguments
  case invalidSocket
  case socketNotBoundYet
  case socketNotListening
  case rendezvousModeIncompatible
  case rendezvousSocketNotBoundYet
  case invalidMessageAPIUsage
  case invalidBufferAPIUsage
  case duplicateListen
  case messageTooLarge
  case invalidEpollID
  case emptyEpollContainer
  case alreadyInUse

  case retriable
  case writeNotAvailable
  case readNotAvailable
  case transmissionTimeout
  case congestionWarning

  case peer

  case cannotEncodeArgument
  case argumentTooLarge
  case argumentOutOfRange

  case srtError(String)

  public var canRetry: Bool {
    switch self {
    case .retriable,
      .writeNotAvailable,
      .readNotAvailable,
      .transmissionTimeout,
      .congestionWarning:
      true
    default: false
    }
  }

  public var description: String {
    switch self {
    case .unknown: "unknown error"
    case .setUp: "connection setup failed"
    case .noServer: "no server available"
    case .rejected: "connection rejected"
    case .socketFailed: "socket failed"
    case .securityIssue: "security issue"
    case .closed: "connection closed"
    case .connection: "connection failed"
    case .connectionLost: "connection lost"
    case .noConnection: "no connection available"
    case .systemResource: "system resource error"
    case .noThread: "no thread available"
    case .noMemory: "no memory available"
    case .noObject: "no object available"
    case .fileSystem: "file system error"
    case .invalidFileReadOffset: "invalid file read offset"
    case .noFileReadPermission: "no file read permission"
    case .invalidFileWriteOffset: "invalid file write offset"
    case .noFileWritePermission: "no file write permission"
    case .notSupported: "operation not supported"
    case .socketAlreadyBound: "socket already bound"
    case .socketAlreadyConnected: "socket already connected"
    case .invalidArguments: "invalid arguments"
    case .invalidSocket: "invalid socket"
    case .socketNotBoundYet: "socket not bound yet"
    case .socketNotListening: "socket not listening"
    case .rendezvousModeIncompatible: "rendezvous mode incompatible"
    case .rendezvousSocketNotBoundYet: "rendezvous socket not bound yet"
    case .invalidMessageAPIUsage: "invalid message API usage"
    case .invalidBufferAPIUsage: "invalid buffer API usage"
    case .duplicateListen: "duplicate listen"
    case .messageTooLarge: "message too large"
    case .invalidEpollID: "invalid epoll ID"
    case .emptyEpollContainer: "empty epoll container"
    case .alreadyInUse: "already in use"
    case .retriable: "retriable"
    case .writeNotAvailable: "write not available"
    case .readNotAvailable: "read not available"
    case .transmissionTimeout: "transmission timeout"
    case .congestionWarning: "congestion warning"
    case .peer: "peer error"
    case .cannotEncodeArgument: "cannot encode argument"
    case .argumentTooLarge: "argument too large"
    case .argumentOutOfRange: "argument out of range"
    case .invalidEndpoint: "invalid endpoint"
    case let .srtError(message): "SRT error: \(message)"
    }
  }

  init(nativeValue: SRT_ERRNO) {
    self =
      switch nativeValue {
      case SRT_EUNKNOWN: .unknown

      case SRT_ECONNSETUP: .setUp
      case SRT_ENOSERVER: .noServer
      case SRT_ECONNREJ: .rejected
      case SRT_ESOCKFAIL: .socketFailed
      case SRT_ESECFAIL: .securityIssue
      case SRT_ESCLOSED: .closed

      case SRT_ECONNFAIL: .connection
      case SRT_ECONNLOST: .connectionLost
      case SRT_ENOCONN: .noConnection

      case SRT_ERESOURCE: .systemResource
      case SRT_ETHREAD: .noThread
      case SRT_ENOBUF: .noMemory
      case SRT_ESYSOBJ: .noObject

      case SRT_EFILE: .fileSystem
      case SRT_EINVRDOFF: .invalidFileReadOffset
      case SRT_ERDPERM: .noFileReadPermission
      case SRT_EINVWROFF: .invalidFileWriteOffset
      case SRT_EWRPERM: .noFileWritePermission

      case SRT_EINVOP: .notSupported
      case SRT_EBOUNDSOCK: .socketAlreadyBound
      case SRT_ECONNSOCK: .socketAlreadyConnected
      case SRT_EINVPARAM: .invalidArguments
      case SRT_EINVSOCK: .invalidSocket
      case SRT_EUNBOUNDSOCK: .socketNotBoundYet
      case SRT_ENOLISTEN: .socketNotListening
      case SRT_ERDVNOSERV: .rendezvousModeIncompatible
      case SRT_ERDVUNBOUND: .rendezvousSocketNotBoundYet
      case SRT_EINVALMSGAPI: .invalidMessageAPIUsage
      case SRT_EINVALBUFFERAPI: .invalidBufferAPIUsage
      case SRT_EDUPLISTEN: .duplicateListen
      case SRT_ELARGEMSG: .messageTooLarge
      case SRT_EINVPOLLID: .invalidEpollID
      case SRT_EPOLLEMPTY: .emptyEpollContainer
      case SRT_EBINDCONFLICT: .alreadyInUse

      case SRT_EASYNCFAIL: .retriable
      case SRT_EASYNCRCV: .readNotAvailable
      case SRT_EASYNCSND: .writeNotAvailable
      case SRT_ETIMEOUT: .transmissionTimeout
      case SRT_ECONGEST: .congestionWarning

      case SRT_EPEERERR: .peer

      default:
        .unknown
      }
  }
}

func checkResult(_ result: Int32) throws {
  guard result >= 0 else {
    throw Error.srtError(String(cString: srt_getlasterror_str()))
  }
}
