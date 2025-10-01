import SRTInterface

struct SRTOptions {
  struct PreBindOptions {  //pre-bind
    var bindToDevice: String?
    var typeOfServiceOfIP: Int?
    var timeToLiveOfIP: Int?
    var IPFamilyOption: IPFamilyOption?
    var maxSegmentSize: Int?
    var receiveBufferSize: Int?
    var reusingAddress: Bool?
    var sendBufferSize: Int?
    var UDPSendBufferSize: Int?
    var UDPReceiveBufferSize: Int?
  }

  struct PreOptions {  //pre
    var congestion: CongestionControllerType?
    var connectionTimeout: Duration?
    var cryptoMode: CryptoMode?
    var isEncryptionEnforced: Bool?
    var maxPacketsInFlight: Int?  //flow control
    var acceptsGroupConnections: Bool?
    var minSwitchPathThreshold: Duration?
    var streamEncryptingKeyInterval: Int?
    var streamEncryptingKeyRefreshRate: Int?
    var linger: Duration?
    var usingMessageAPI: Bool?
    var minPeerVersion: Int?
    var reportsNAK: Bool?
    var packetFilter: String?
    var passphrase: String?
    var payloadSize: Int?
    var keyLength: Int?
    var peerIdleTimeout: Duration?
    var peerLatency: Duration?
    var receiveLatency: Duration?
    var usingRendezvous: Bool?
    var retransmissionAlgorithm: RetransmissionAlgorithm?
    var streamID: String?
    var isTooLatePacketDropEnabled: Bool?
    var usingTimestampBasedPacketDeliveryMode: Bool?
    var transmissionType: TransmissionType?
  }

  struct PostOptions {  //post
    var isDriftTracerEnabled: Bool?
    var inputBandwidth: Int?
    var minInputBandwidth: Int?
    var maxTimeToLiveOfLoss: Duration?
    var maxBandwidth: MaxBandwidthOption?
    var maxRetransmissionBandwidth: MaxRetransmissionBandwidthOption?
    var recoveryOverheadPercentage: Int?
    var isReadingBlocking: Bool?
    var receiveTimeout: Duration?
    var sendDropDelay: Duration?
    var isSendingBlocking: Bool?
    var sendTimeout: Duration?
  }

  struct OptionReadings {  //read
    var bindToDevice: String?
    var isDriftTracerEnabled: Bool?
    var epollEvent: EpollOptions?
    var maxPacketsInFlight: Int?
    var inputBandwidth: Int?
    var minInputBandwidth: Int?
    var typeOfServiceOfIP: Int?
    var timeToLiveOfIP: Int?
    var isIPv6Only: IPFamilyOption?
    var streamEncryptingKeyInterval: Int?
    var streamEncryptingKeyRefreshRate: Int?
    var senderKeyMaterialState: KeyMaterialState?
    var receiverKeyMaterialState: KeyMaterialState?
    var linger: Duration?
    var maxTimeToLiveOfLoss: Duration?
    var maxBandwidth: MaxBandwidthOption?
    var maxRetransmissionBandwidth: MaxRetransmissionBandwidthOption?
    var minPeerVersion: Int?
    var maxSegmentSize: Int?
    var reportsNAK: Bool?
    var recoveryOverheadPercentage: Int?
    var packetFilter: String?
    var keyLength: Int?
    var peerIdleTimeout: Duration?
    var peerLatency: Duration?
    var peerVersion: Int?
    var receiveBufferSize: Int?
    var receivedDataSize: Int?
    var keyMaterialState: KeyMaterialState?
    var receiveLatency: Duration?
    var isReadingBlocking: Bool?
    var receiveTimeout: Duration?
    var usingRendezvous: Bool?
    var retransmissionAlgorithm: RetransmissionAlgorithm?
    var reusingAddress: Bool?
    var sendBufferSize: Int?
    var sendingDataSize: Int?
    var peerKeyMaterialState: KeyMaterialState?
    var isSendingBlocking: Bool?
    var sendTimeout: Duration?
    var state: SRTSocket.Status?
    var streamID: String?
    var isTooLatePacketDropEnabled: Bool?
    var localVersion: Int?
    var UDPSendBufferSize: Int?
    var UDPReceiveBufferSize: Int?
  }
}

extension SRTOptions {
  enum CongestionControllerType: String {
    case live, file
  }

  enum CryptoMode: Int {
    case auto = 0
    case AES_CTR
    case AES_GCM
  }

  struct EpollOptions: OptionSet {
    let rawValue: Int
    static let none: EpollOptions = []
    static let `in` = EpollOptions(rawValue: 0x01)
    static let out = EpollOptions(rawValue: 0x04)
    static let error = EpollOptions(rawValue: 0x08)
    static let connection = EpollOptions.out
    static let accept = EpollOptions.in
    static let update = EpollOptions(rawValue: 0x10)
    static let et = EpollOptions(rawValue: 1 << 31)
  }

  enum IPFamilyOption: Int {
    case system = -1
    case both = 0
    case ipv6Only = 1
  }

  enum KeyMaterialState: Int {
    case unsecured = 0
    case securing
    case secured
    case noSecret
    case badSecret
    case badCryptoMode
  }

  enum MaxBandwidthOption {
    case infinite
    case relativeToInputRate
    case absolute(Int)
  }

  enum MaxRetransmissionBandwidthOption {
    case infinite
    case forbidden
    case absolute(Int)
  }

  enum RetransmissionAlgorithm: Int {
    case aggressive = 0
    case efficient
  }

  enum TransmissionType: Int {
    case live = 0
    case file
  }
}

extension Duration {
  static let noLimitInMilliseconds = Duration.milliseconds(-1)
}
