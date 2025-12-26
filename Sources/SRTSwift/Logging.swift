import LogContext
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

private let style: ByteCountFormatStyle = ByteCountFormatStyle(
  style: .binary,
  allowedUnits: [.bytes, .kb, .mb],
  spellsOutZero: true,
  includesActualByteCount: false,
  locale: Locale(identifier: "en_US"),
)
extension BinaryInteger {
  var formattedSize: String {
    formatted(style)
  }

  var formattedBandwidth: String {
    formattedSize + "/s"
  }
}

extension Double {
  var formattedSize: String {
    Int(self).formatted(style)
  }

  var formattedBandwidth: String {
    formattedSize + "/s"
  }
}

extension Duration {
  var formattedMilliseconds: String {
    formatted(
      .units(allowed: [.milliseconds], width: .condensedAbbreviated)
    )
  }
}
