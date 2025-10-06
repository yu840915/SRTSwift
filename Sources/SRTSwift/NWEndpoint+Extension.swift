import Network

extension NWEndpoint {
  var socketaddr_in: sockaddr_in? {
    var retVal = sockaddr_in()
    retVal.sin_family = sa_family_t(AF_INET)
    switch self {
    case .hostPort(let host, let port):
      retVal.sin_port = in_port_t(port.rawValue).bigEndian
      switch host {
      case let .ipv4(addr):
        retVal.sin_addr = convertIPv4Address(addr)
        return retVal
      case .name(let name, _):
        if let addr = convertHostName(name) {
          retVal.sin_addr = addr
          return retVal
        } else {
          return nil
        }
      case .ipv6: return nil
      @unknown default:
        return nil
      }
    default:
      return nil
    }
  }

  func convertIPv4Address(_ addr: IPv4Address) -> in_addr {
    var retVal = in_addr()
    retVal.s_addr = addr.rawValue.withUnsafeBytes { $0.load(as: UInt32.self) }.bigEndian
    return retVal
  }

  func convertHostName(_ host: String) -> in_addr? {
    guard
      let entry = gethostbyname(host),
      entry.pointee.h_addrtype == AF_INET
    else {
      return nil
    }
    if let list = entry.pointee.h_addr_list[0] {
      return UnsafeRawPointer(list).assumingMemoryBound(to: in_addr.self).pointee
    } else {
      return nil
    }
  }
}
