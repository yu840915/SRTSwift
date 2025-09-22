import SRTInterface
import SRTSwift
import Testing

struct ErrorTests {
  @Test(
    "SRT error cases",
    arguments: [
      SRT_EUNKNOWN,
      SRT_SUCCESS,
      SRT_ECONNSETUP,
    ],
  )
  func fullyMatchSRTErrors(_ srtErr: SRT_ERRNO) async throws {
    let result = SRTResult(nativeValue: srtErr)
    switch srtErr {
    case SRT_EUNKNOWN:
      let test =
        if case .failure(.unknown) = result { true } else { false }
      #expect(test)
    case SRT_SUCCESS:
      let test =
        if case .success = result { true } else { false }
      #expect(test)
    case SRT_ECONNSETUP:
      let test =
        if case .failure(.setUp) = result { true } else { false }
      #expect(test)
    case SRT_ENOSERVER:
      let test =
        if case .failure(.noServer) = result { true } else { false }
      #expect(test)
    default: break
    }
  }
}
