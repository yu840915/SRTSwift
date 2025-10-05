extension Duration {
  var milliseconds: Int {
    Int(components.seconds * 1_000 + components.attoseconds / 1_000_000_000_000_000)
  }

  var seconds: Int {
    Int(components.seconds)
  }
}
