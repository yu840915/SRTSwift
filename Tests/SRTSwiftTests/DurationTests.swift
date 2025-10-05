import Testing

@testable import SRTSwift

struct DurationTests {
  @Test
  func integerMilliseconds() async throws {
    let sut = Duration.milliseconds(-1)

    #expect(sut.milliseconds == -1)
  }
}
