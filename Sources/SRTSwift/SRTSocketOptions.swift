import SRTInterface

public struct SRTOptions {
  public struct PreBindOptions: Sendable {  //pre-bind
    public var bindToDevice: String?
    public var typeOfServiceOfIP: Int?
    public var IPTTL: Int?
    public var IPFamilyOption: IPFamilyOption?
    public var maxSegmentSize: Int?
    public var receiveBufferSize: Int?
    public var reusingAddress: Bool?
    public var sendBufferSize: Int?
    public var UDPSendBufferSize: Int?
    public var UDPReceiveBufferSize: Int?

    public init(_ builder: SRTOptionBuilder<PreBindOptions>? = nil) {
      builder?(&self)
    }
  }

  public struct PreOptions: Sendable {  //pre
    public var congestion: CongestionControllerType?
    public var connectionTimeout: Duration?
    public var cryptoMode: CryptoMode?
    public var isEncryptionEnforced: Bool?
    public var maxPacketsInFlight: Int?  //flow control
    public var acceptsGroupConnections: Bool?
    public var minSwitchPathThreshold: Duration?
    public var streamEncryptingKeyInterval: Int?
    public var streamEncryptingKeyRefreshRate: Int?
    public var latency: Duration?
    public var usingMessageAPI: Bool?
    public var minPeerVersion: Int?
    public var reportsNAK: Bool?
    public var packetFilter: String?
    public var passphrase: String?
    public var payloadSize: Int?
    public var keyLength: Int?
    public var peerIdleTimeout: Duration?
    public var peerLatency: Duration?
    public var receiveLatency: Duration?
    public var usingRendezvous: Bool?
    public var retransmissionAlgorithm: RetransmissionAlgorithm?
    public var streamID: SRTStreamID?
    public var shouldDropTooLatePacket: Bool?
    public var usingTimestampBasedPacketDeliveryMode: Bool?
    public var transmissionType: TransmissionType?

    public init(_ builder: SRTOptionBuilder<PreOptions>? = nil) {
      builder?(&self)
    }
  }

  public struct PostOptions: Sendable {  //post
    public var isDriftTracerEnabled: Bool?
    public var inputBandwidth: Int?
    public var linger: Duration?
    public var minInputBandwidth: Int?
    public var maxLossTTL: Duration?
    public var maxBandwidth: MaxBandwidthOption?
    public var maxRetransmissionBandwidth: MaxRetransmissionBandwidthOption?
    public var recoveryOverheadPercentage: Int?
    public var isReadingBlocking: Bool?
    public var receiveTimeout: Duration?
    public var sendDropDelay: Duration?
    public var isSendingBlocking: Bool?
    public var sendTimeout: Duration?

    public init(_ builder: SRTOptionBuilder<PostOptions>? = nil) {
      builder?(&self)
    }
  }

  public struct OptionReadings: Sendable {  //read
    public var bindToDevice: String?
    public var isDriftTracerEnabled: Bool?
    public var epollEvent: EpollOptions?
    public var maxPacketsInFlight: Int?
    public var inputBandwidth: Int?
    public var minInputBandwidth: Int?
    public var typeOfServiceOfIP: Int?
    public var timeToLiveOfIP: Int?
    public var isIPv6Only: IPFamilyOption?
    public var streamEncryptingKeyInterval: Int?
    public var streamEncryptingKeyRefreshRate: Int?
    public var senderKeyMaterialState: KeyMaterialState?
    public var receiverKeyMaterialState: KeyMaterialState?
    public var linger: Duration?
    public var maxTimeToLiveOfLoss: Duration?
    public var maxBandwidth: MaxBandwidthOption?
    public var maxRetransmissionBandwidth: MaxRetransmissionBandwidthOption?
    public var minPeerVersion: Int?
    public var maxSegmentSize: Int?
    public var reportsNAK: Bool?
    public var recoveryOverheadPercentage: Int?
    public var packetFilter: String?
    public var keyLength: Int?
    public var peerIdleTimeout: Duration?
    public var peerLatency: Duration?
    public var peerVersion: Int?
    public var receiveBufferSize: Int?
    public var receivedDataSize: Int?
    public var keyMaterialState: KeyMaterialState?
    public var receiveLatency: Duration?
    public var isReadingBlocking: Bool?
    public var receiveTimeout: Duration?
    public var usingRendezvous: Bool?
    public var retransmissionAlgorithm: RetransmissionAlgorithm?
    public var reusingAddress: Bool?
    public var sendBufferSize: Int?
    public var sendingDataSize: Int?
    public var peerKeyMaterialState: KeyMaterialState?
    public var isSendingBlocking: Bool?
    public var sendTimeout: Duration?
    public var state: SRTSocket.Status?
    public var streamID: String?
    public var isTooLatePacketDropEnabled: Bool?
    public var localVersion: Int?
    public var UDPSendBufferSize: Int?
    public var UDPReceiveBufferSize: Int?
  }
}

extension SRTOptions {
  public enum CongestionControllerType: String, Sendable {
    case live, file
  }

  public enum CryptoMode: Int, Sendable {
    case auto = 0
    case AES_CTR
    case AES_GCM
  }

  public struct EpollOptions: OptionSet, Sendable {
    public let rawValue: Int
    public static let none: EpollOptions = []
    public static let `in` = EpollOptions(rawValue: 0x01)
    public static let out = EpollOptions(rawValue: 0x04)
    public static let error = EpollOptions(rawValue: 0x08)
    public static let connection = EpollOptions.out
    public static let accept = EpollOptions.in
    public static let update = EpollOptions(rawValue: 0x10)
    public static let et = EpollOptions(rawValue: 1 << 31)

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
  }

  public enum IPFamilyOption: Int, Sendable {
    case system = -1
    case both = 0
    case ipv6Only = 1
  }

  public enum KeyMaterialState: Int, Sendable {
    case unsecured = 0
    case securing
    case secured
    case noSecret
    case badSecret
    case badCryptoMode
  }

  public enum MaxBandwidthOption: Sendable {
    case infinite
    case relativeToInputRate
    case absolute(Int)
  }

  public enum MaxRetransmissionBandwidthOption: Sendable {
    case infinite
    case forbidden
    case absolute(Int)
  }

  public enum RetransmissionAlgorithm: Int, Sendable {
    case aggressive = 0
    case efficient
  }

  public enum TransmissionType: Int, Sendable {
    case live = 0
    case file
  }
}

extension Duration {
  public static let noLimitInMilliseconds = Duration.milliseconds(-1)
}
