import Foundation
import Network

extension NWEndpoint {
  var socketaddr_in: sockaddr_in? {
    var retVal = sockaddr_in()
    retVal.sin_family = sa_family_t(AF_INET)
    switch self {
    case let .hostPort(host, port):
      retVal.sin_port = in_port_t(port.rawValue.bigEndian)
      switch host {
      case let .ipv4(addr):
        retVal.sin_addr = convertIPv4Address(addr)
        return retVal
      case let .name(name, _):
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
    retVal.s_addr = addr.rawValue.withUnsafeBytes { $0.load(as: UInt32.self) }
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

extension NWEndpoint: @retroactive CustomStringConvertible {
  public var description: String {
    switch self {
    case let .hostPort(host, port):
      "NWEndpoint.hostPort(host: \(host), port: \(port))"
    case let .service(name, type, domain, interface):
      "NWEndpoint.service(name: \(name), type: \(type), domain: \(domain), interface: \(interface?.description ?? "nil"))"
    case let .unix(path):
      "NWEndpoint.unix(path: \(path))"
    case let .url(url):
      "NWEndpoint.url(\(url))"
    case .opaque:
      "NWEndpoint.opaque"
    @unknown default:
      "NWEndpoint.unknown"
    }
  }
}

extension NWInterface: @retroactive CustomStringConvertible {
  public var description: String {
    return "NWInterface(name: \(name), type: \(type))"
  }
}

extension NWInterface.InterfaceType: @retroactive CustomStringConvertible {
  public var description: String {
    switch self {
    case .other: "other"
    case .wifi: "wifi"
    case .cellular: "cellular"
    case .wiredEthernet: "wiredEthernet"
    case .loopback: "loopback"
    @unknown default: "unknown"
    }
  }
}

extension sockaddr: @retroactive CustomStringConvertible {
  public var description: String {
    switch Int32(sa_family) {
    case AF_INET:
      var addr_in = sockaddr_in()
      var addr = self
      memcpy(&addr_in, &addr, MemoryLayout<sockaddr_in>.size)
      let ip = String(cString: inet_ntoa(addr_in.sin_addr))
      let port = UInt16(bigEndian: addr_in.sin_port)
      return "sockaddr_in(\(ip):\(port))"
    case AF_INET6:
      var addr_in = sockaddr_in6()
      var addr = self
      memcpy(&addr_in, &addr, MemoryLayout<sockaddr_in6>.size)
      var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
      let ipPtr = inet_ntop(AF_INET6, &addr_in.sin6_addr, &buffer, socklen_t(INET6_ADDRSTRLEN))
      let ip = String(cString: ipPtr!)
      let port = UInt16(bigEndian: addr_in.sin6_port)
      return "sockaddr_in6([\(ip)]:\(port))"
    default:
      return "Unknown address family"
    }
  }
}
