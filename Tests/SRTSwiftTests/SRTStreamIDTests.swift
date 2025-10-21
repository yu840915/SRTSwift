import Testing

@testable import SRTSwift

struct SRTStreamIDTests {
  @Test
  func builderInitializer() async throws {
    let sut = SRTStreamID {
      $0.userName = "user1"
      $0.resourceName = "resource1"
      $0.mode = .publish
    }

    #expect(sut.userName == "user1")
    #expect(sut.resourceName == "resource1")
    #expect(sut.mode == .publish)
  }

  @Test func stringValue() async throws {
    var sut = SRTStreamID()
    sut.userName = "user1"
    sut.resourceName = "resource1"
    sut.mode = .publish

    #expect(sut.stringValue == "#!::u=user1,r=resource1,m=publish")
  }
}
