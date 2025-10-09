import OSLog

enum Loggers: String {
  case connector
  case socket

  func build() -> Logger {
    return Logger(
      subsystem: "com.teleshot.SRTSwift",
      category: rawValue,
    )
  }
}
