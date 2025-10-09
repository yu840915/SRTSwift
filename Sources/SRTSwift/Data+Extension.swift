import Foundation

extension Data {
  func chunk(by size: Int) -> [Data] {
    var chunks: [Data] = []
    var offset = 0
    while offset < self.count {
      let chunkSize = Swift.min(size, self.count - offset)
      let chunk = self.subdata(in: offset..<offset + chunkSize)
      chunks.append(chunk)
      offset += chunkSize
    }
    return chunks
  }
}
