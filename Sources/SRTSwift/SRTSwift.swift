import SRTInterface

func initializeSRT() throws {
  try checkResult(srt_startup())
}
