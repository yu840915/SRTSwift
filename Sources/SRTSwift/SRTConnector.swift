import AsyncUtils
import Combine
import Foundation
import Network
import SRTInterface

extension SRTConnector {
  public enum Action {
    case invite
    case listen
  }
}

public actor SRTConnector {
  let socketID: SRTSOCKET
  let address: sockaddr
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
    guard var addr = endpoint.socketaddr_in else {
      throw Error.invalidEndpoint
    }
    let len = MemoryLayout<sockaddr_in>.size
    var sockaddr = sockaddr()
    memcpy(&sockaddr, &addr, len)
    self.address = sockaddr
    self.addressLength = len
    let socket = srt_create_socket()
    guard socket != SRT_INVALID_SOCK else {
      throw Error.srtError(String(cString: srt_getlasterror_str()))
    }
    self.socketID = socket
    self.action = action
    configurer = SRTConfigurer(socketID: socketID)
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
      await completor?.resume(SRTSocket(socketID: sockId))
    } catch {
      await completor?.resume(throwing: error)
    }
  }

  func invite() throws -> SRTSOCKET {
    var addr = address
    try checkResult(srt_connect(socketID, &addr, Int32(addressLength)))
    return socketID
  }

  func listen() throws -> SRTSOCKET {
    var addr = address
    try checkResult(srt_bind(socketID, &addr, Int32(addressLength)))
    try checkResult(srt_listen(socketID, 1))
    var sockID = socketID
    let socket = srt_accept_bond(&sockID, 1, -100)
    guard socket != SRT_INVALID_SOCK else {
      throw Error.srtError(String(cString: srt_getlasterror_str()))
    }
    return socket
  }
}
