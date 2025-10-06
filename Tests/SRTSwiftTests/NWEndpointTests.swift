import Network
import Testing

@testable import SRTSwift

struct NWEndpointTests {
  @Test
  func convertIPv4EndpointToSockaddr() async throws {
    let sut = NWEndpoint.hostPort(
      host: .ipv4(.loopback),
      port: NWEndpoint.Port(8080),
    )

    #expect(sut.socketaddr_in != nil)
  }

  @Test
  func convertStringHostNameToSockaddr() async throws {
    let sut = NWEndpoint.hostPort(
      host: .name("localhost", nil),
      port: NWEndpoint.Port(8080),
    )

    #expect(sut.socketaddr_in != nil)
  }
}
