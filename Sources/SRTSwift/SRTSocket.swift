import Combine
import Foundation
import Network
import SRTInterface

public actor SRTSocket {
  let socketID: SRTSOCKET
  private let configurer: SRTConfigurer
  private let data$: PassthroughSubject<Data, Never>
  private let status$: CurrentValueSubject<SRTSocket.Status, Never>
  public var onStatus: any Publisher<SRTSocket.Status, Never> {
    status$
  }
  public var onData: any Publisher<Data, Never> {
    data$
  }

  init(socketID: SRTSOCKET) {
    self.socketID = socketID
    data$ = .init()
    status$ = .init(.setUp)
    configurer = SRTConfigurer(socketID: socketID)
  }

  func setOptions(_ options: SRTOptions.PostOptions) throws {
    try configurer.setPostOptions(options)
  }

  private func updateStatus() {
    let status = SRTSocket.Status(nativeValue: srt_getsockstate(socketID))
    if status != status$.value {
      status$.send(status)
    }
  }
}
