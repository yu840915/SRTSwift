import SRTInterface

public func initializeSRT() throws {
  try checkResult(srt_startup())
}
