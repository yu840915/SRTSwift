import AsyncUtils
import Combine
import Foundation
import Network
import SRTInterface

private let logger = Loggers.connector.build()

extension SRTConnector {
  public enum Action: Sendable {
    case invite
    case listen

    var isSender: Bool {
      switch self {
      case .invite: true
      case .listen: false
      }
    }
  }
}

public actor SRTConnector {
  let socketID: SRTSOCKET
  let address_in: sockaddr_in
  let addressLength: Int
  let action: Action
  let configurer: SRTConfigurer
  private var completor: ThrowingCompleter<SRTSocket>?
  private(set) var isStarted = false

  public init(
    endpoint: NWEndpoint,
    options: SRTOptions.PreBindOptions,
    action: Action
  ) async throws {
    guard let addr = endpoint.socketaddr_in else {
      throw Error.invalidEndpoint
    }
    address_in = addr
    let len = MemoryLayout<sockaddr_in>.size
    addressLength = len
    let socket = srt_create_socket()
    guard socket != SRT_INVALID_SOCK else {
      throw Error.srtError(String(cString: srt_getlasterror_str()))
    }
    socketID = socket
    self.action = action
    logger.debug("Created SRT connector")
    configurer = SRTConfigurer(socketID: socketID)
    try configurer.setOption(name: SRTO_SENDER, value: action.isSender)
    try configurer.setPreBindOptions(options)
  }

  deinit {
    srt_close(socketID)
  }

  public func setOptions(_ options: SRTOptions.PostOptions) throws {
    try configurer.setPostOptions(options)
  }

  public func prepareSocket(
    with options: SRTOptions.PreOptions
  ) async throws -> SRTSocket {
    if let completor {
      return try await completor.result()
    }
    logger.debug("Will prepare SRT socket")
    let completor = await ThrowingCompleter<SRTSocket>()
    self.completor = completor
    try configurer.setPreOptions(options)
    Task { [weak self] in
      await self?.connect()
    }
    return try await completor.result()
  }

  func connect() async {
    do {
      let sockId =
        switch action {
        case .invite: try invite()
        case .listen: try listen()
        }
      logger.debug("Socket connected \(sockId)")
      await completor?.resume(SRTSocket(socketID: sockId))
    } catch {
      logger.warning("Fail to connect, \(error.localizedDescription)")
      await completor?.resume(throwing: error)
    }
  }

  func invite() throws -> SRTSOCKET {
    logger.debug("Start inviting")
    var sockaddr = sockaddr()
    var addr = address_in
    memcpy(&sockaddr, &addr, addressLength)
    try checkResult(srt_connect(socketID, &sockaddr, Int32(addressLength)))
    return socketID
  }

  func listen() throws -> SRTSOCKET {
    var sockaddr = sockaddr()
    var addr = sockaddr_in()
    addr.sin_port = address_in.sin_port
    addr.sin_family = address_in.sin_family
    memcpy(&sockaddr, &addr, addressLength)
    logger.debug("Start binding")
    try checkResult(srt_bind(socketID, &sockaddr, Int32(addressLength)))
    logger.debug("Start listening")
    try checkResult(srt_listen(socketID, 1))
    logger.debug("Start accepting")
    let socket = srt_accept(socketID, nil, nil)
    logger.debug("Accepted socket \(socket)")
    guard socket != SRT_INVALID_SOCK else {
      throw Error.srtError(String(cString: srt_getlasterror_str()))
    }
    return socket
  }
}
