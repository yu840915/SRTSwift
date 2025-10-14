import AsyncUtils
import Combine
import Foundation
import Network
import SRTInterface

private let logger = Loggers.socket.build()

public actor SRTSocket {
  let socketID: SRTSOCKET
  private let configurer: SRTConfigurer
  private let data$: PassthroughSubject<Data, Never>
  private let status$: CurrentValueSubject<SRTSocket.Status, Never>
  private let sendChunkSize = 1316
  private let readBufferSize = 4 * 1024
  private var readBuffer: Data
  private var wantsReading = false
  private var currentReading: Task<Void, Never>?
  public var onStatus: NonSendable<any Publisher<SRTSocket.Status, Never>> {
    NonSendable(status$)
  }
  public var onData: NonSendable<any Publisher<Data, Never>> {
    NonSendable(data$)
  }

  init(socketID: SRTSOCKET) {
    self.socketID = socketID
    readBuffer = Data(count: readBufferSize)
    data$ = .init()
    status$ = .init(.setUp)
    configurer = SRTConfigurer(socketID: socketID)
    Task { [weak self] in
      await self?.updateStatus()
    }
  }

  deinit {
    currentReading?.cancel()
  }

  public func startReading() {
    guard !wantsReading else { return }
    wantsReading = true
    readLoop()
  }

  public func stopReading() {
    guard wantsReading else { return }
    wantsReading = false
    currentReading?.cancel()
    currentReading = nil
  }

  public func setOptions(_ options: SRTOptions.PostOptions) throws {
    try configurer.setPostOptions(options)
  }

  public func send(_ data: Data) throws {
    try data.chunk(by: sendChunkSize).forEach { chunk in
      try sendChunk(chunk)
    }
  }
}

extension SRTSocket {
  private func sendChunk(_ data: Data) throws {
    try data.withUnsafeBytes { pointer in
      guard
        let buffer = pointer.baseAddress?.assumingMemoryBound(to: CChar.self)
      else {
        throw Error.unknown
      }
      try checkResult(srt_send(socketID, buffer, Int32(data.count)))
    }
  }

  private func updateStatus() {
    let status = SRTSocket.Status(nativeValue: srt_getsockstate(socketID))
    if status != status$.value {
      status$.send(status)
    }
  }

  private func readLoop() {
    currentReading = Task.detached { [weak self] in
      do {
        if let result = try await self?.readData() {
          if result {
            await self?.readLoop()
          }
        }
      } catch {
        logger.info("Stop reading, error: \(error.localizedDescription)")
      }
    }
  }

  private func readData() throws -> Bool {
    guard !Task.isCancelled else { return false }
    guard wantsReading else { return false }
    updateStatus()
    let result = readBuffer.withUnsafeMutableBytes { pointer in
      guard
        let buffer = pointer.baseAddress?.assumingMemoryBound(to: CChar.self)
      else {
        return SRT_ERROR
      }
      return srt_recvmsg(socketID, buffer, Int32(readBufferSize))
    }
    guard !Task.isCancelled else { return false }
    guard wantsReading else { return false }
    if result > 0 {
      data$.send(readBuffer.prefix(Int(result)))
      return true
    } else {
      wantsReading = false
      try checkResult(result)
      updateStatus()
      return false
    }
  }
}
