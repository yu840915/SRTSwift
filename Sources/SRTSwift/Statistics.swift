import LogContext
import SRTInterface

private let megabits: Double = 1000 * 1000
public struct Statistics {
  public var duration: Duration

  public var totalPackets: SendingReceiving<UInt>
  public var totalPacketsLost: SendingReceiving<Int>
  public var totalPacketsRetransmitted: Int
  public var totalACK: SendingReceiving<Int>
  public var totalNAK: SendingReceiving<Int>

  public var totalSendDuration: Duration
  public var totalPacketsDropped: SendingReceiving<Int>
  public var totalReceivedPacketsUndecrypted: Int

  public var totalBytes: SendingReceiving<UInt>
  public var totalReceivedBytesLost: UInt
  public var totalReceivedBytesUndecrypted: UInt
  public var totalRetransmittedBytes: UInt
  public var totalBytesDropped: SendingReceiving<UInt>
  public var totalUniquePackets: SendingReceiving<UInt>
  public var totalUniqueBytes: SendingReceiving<UInt>
  public var totalExtraControlPackets: SendingReceiving<Int>
  public var totalFilterSuppliedPackets: Int
  public var totalPacketsLossFromFilter: Int

  public var packets: SendingReceiving<Int>
  public var packetsLost: SendingReceiving<Int>
  public var packetsDropped: SendingReceiving<Int>
  public var packetsRetransmitted: SendingReceiving<Int>
  public var packetsACK: SendingReceiving<Int>
  public var packetsNAK: SendingReceiving<Int>
  public var bandwidths: SendingReceiving<Double>
  public var busySendingDuration: Duration
  public var receivedPacketReorderDistance: Int
  public var averageReceivedPacketsBelatedTime: Duration
  public var belatedReceivedPackets: UInt
  public var receivedPacketsUndecrypted: Int
  public var uniquePackets: SendingReceiving<UInt>
  public var uniqueBytes: SendingReceiving<UInt>
  public var extraControlPackets: SendingReceiving<UInt>
  public var filterSuppliedPackets: UInt
  public var packetsLossFromFilter: UInt
  public var packetReorderTolerance: UInt

  public var bytes: SendingReceiving<UInt>
  public var bytesDropped: SendingReceiving<UInt>
  public var receivedBytesLost: UInt
  public var bytesRetransmitted: UInt
  public var receivedBytesUndecrypted: UInt
  public var maxBandwidth: UInt
  public var timeBasedPacketDeliveryDelays: SendingReceivingDuration
  public var unACKedUndeliveredPackets: SendingReceiving<UInt>
  public var unACKedUndeliveredBytes: SendingReceiving<UInt>
  public var unACKedUndeliveredTimespan: SendingReceivingDuration
  public var maxSegmentSize: Int

  public var instantaneousMeasurements: Measurements

  init(nativeValue: CBytePerfMon) {
    instantaneousMeasurements = .init(nativeValue: nativeValue)
    duration = Duration.milliseconds(Double(nativeValue.msTimeStamp))
    totalPackets = .init(
      send: UInt(nativeValue.pktSentTotal),
      receive: UInt(nativeValue.pktRecvTotal),
    )
    totalPacketsLost = .init(
      send: Int(nativeValue.pktSndLossTotal),
      receive: Int(nativeValue.pktRcvLossTotal),
    )
    totalPacketsRetransmitted = Int(nativeValue.pktRetransTotal)
    totalACK = .init(
      send: Int(nativeValue.pktSentACKTotal),
      receive: Int(nativeValue.pktRecvACKTotal),
    )
    totalNAK = .init(
      send: Int(nativeValue.pktSentNAKTotal),
      receive: Int(nativeValue.pktRecvNAKTotal),
    )
    totalSendDuration = Duration.microseconds(Double(nativeValue.usSndDurationTotal))
    totalPacketsDropped = .init(
      send: Int(nativeValue.pktSndDropTotal),
      receive: Int(nativeValue.pktRcvDropTotal),
    )
    totalReceivedPacketsUndecrypted = Int(nativeValue.pktRcvUndecryptTotal)

    totalBytes = .init(
      send: UInt(nativeValue.byteSentTotal),
      receive: UInt(nativeValue.byteRecvTotal),
    )
    totalReceivedBytesLost = UInt(nativeValue.byteRcvLossTotal)
    totalReceivedBytesUndecrypted = UInt(nativeValue.byteRcvUndecryptTotal)
    totalRetransmittedBytes = UInt(nativeValue.byteRetransTotal)
    totalBytesDropped = .init(
      send: UInt(nativeValue.byteSndDropTotal),
      receive: UInt(nativeValue.byteRcvDropTotal),
    )
    totalUniquePackets = .init(
      send: UInt(nativeValue.pktSentUniqueTotal),
      receive: UInt(nativeValue.pktRecvUniqueTotal),
    )
    totalUniqueBytes = .init(
      send: UInt(nativeValue.byteSentUniqueTotal),
      receive: UInt(nativeValue.byteRecvUniqueTotal),
    )
    totalExtraControlPackets = .init(
      send: Int(nativeValue.pktSndFilterExtraTotal),
      receive: Int(nativeValue.pktRcvFilterExtraTotal),
    )
    totalFilterSuppliedPackets = Int(nativeValue.pktRcvFilterSupplyTotal)
    totalPacketsLossFromFilter = Int(nativeValue.pktRcvFilterLossTotal)

    packets = .init(
      send: Int(nativeValue.pktSent),
      receive: Int(nativeValue.pktRecv),
    )
    packetsLost = .init(
      send: Int(nativeValue.pktSndLoss),
      receive: Int(nativeValue.pktRcvLoss),
    )
    packetsDropped = .init(
      send: Int(nativeValue.pktSndDrop),
      receive: Int(nativeValue.pktRcvDrop),
    )
    packetsRetransmitted = .init(
      send: Int(nativeValue.pktRetrans),
      receive: Int(nativeValue.pktRcvRetrans)
    )
    packetsACK = .init(
      send: Int(nativeValue.pktSentACK),
      receive: Int(nativeValue.pktRecvACK),
    )
    packetsNAK = .init(
      send: Int(nativeValue.pktSentNAK),
      receive: Int(nativeValue.pktRecvNAK),
    )
    bandwidths = .init(
      send: Double(nativeValue.mbpsSendRate) * megabits,
      receive: Double(nativeValue.mbpsRecvRate) * megabits,
    )
    busySendingDuration = Duration.microseconds(Double(nativeValue.usSndDuration))
    receivedPacketReorderDistance = Int(nativeValue.pktReorderDistance)
    averageReceivedPacketsBelatedTime = Duration.microseconds(nativeValue.pktRcvAvgBelatedTime)
    belatedReceivedPackets = UInt(nativeValue.pktRcvBelated)
    receivedPacketsUndecrypted = Int(nativeValue.pktRcvUndecrypt)
    uniquePackets = .init(
      send: UInt(nativeValue.pktSentUnique),
      receive: UInt(nativeValue.pktRecvUnique),
    )
    uniqueBytes = .init(
      send: UInt(nativeValue.byteSentUnique),
      receive: UInt(nativeValue.byteRecvUnique),
    )
    extraControlPackets = .init(
      send: UInt(nativeValue.pktSndFilterExtra),
      receive: UInt(nativeValue.pktRcvFilterExtra),
    )
    filterSuppliedPackets = UInt(nativeValue.pktRcvFilterSupply)
    packetsLossFromFilter = UInt(nativeValue.pktRcvFilterLoss)
    packetReorderTolerance = UInt(nativeValue.pktReorderTolerance)

    bytes = .init(
      send: UInt(nativeValue.byteSent),
      receive: UInt(nativeValue.byteRecv),
    )
    bytesDropped = .init(
      send: UInt(nativeValue.byteSndDrop),
      receive: UInt(nativeValue.byteRcvDrop),
    )
    receivedBytesLost = UInt(nativeValue.byteRcvLoss)
    bytesRetransmitted = UInt(nativeValue.byteRetrans)
    receivedBytesUndecrypted = UInt(nativeValue.byteRcvUndecrypt)
    maxBandwidth = UInt(nativeValue.mbpsMaxBW * megabits)
    timeBasedPacketDeliveryDelays = .init(
      send: Duration.milliseconds(nativeValue.msSndTsbPdDelay),
      receive: Duration.milliseconds(nativeValue.msRcvTsbPdDelay),
    )
    unACKedUndeliveredPackets = .init(
      send: UInt(nativeValue.pktSndBuf),
      receive: UInt(nativeValue.pktRcvBuf),
    )
    unACKedUndeliveredBytes = .init(
      send: UInt(nativeValue.byteSndBuf),
      receive: UInt(nativeValue.byteRcvBuf),
    )
    unACKedUndeliveredTimespan = .init(
      send: Duration.milliseconds(nativeValue.msSndBuf),
      receive: Duration.milliseconds(nativeValue.msRcvBuf),
    )
    maxSegmentSize = Int(nativeValue.byteMSS)
  }
}

extension Statistics {
  public struct SendingReceiving<T: Numeric> {
    public var send: T
    public var receive: T
  }
  public struct SendingReceivingDuration {
    public var send: Duration
    public var receive: Duration
  }

  public struct Measurements: LogContextReading {
    public var packetSendingPeriod: Duration
    public var flowWindowSizeInPackets: Int
    public var congestionWindowSizeInPackets: Int
    public var onFlightPackets: Int
    public var rtt: Duration
    public var bandwidth: Int
    public var availableBufferInBytes: SendingReceiving<Int>

    public var logContext: LogContext {
      LogContext {
        $0["rtt"] = rtt.formattedMilliseconds
        $0["bandwidth"] = bandwidth.formattedBandwidth
        $0.setDebugDetail {
          $0["sndPeriod"] = packetSendingPeriod.formattedMilliseconds
          $0["flowWindow"] = flowWindowSizeInPackets
          $0["congestionWindow"] = congestionWindowSizeInPackets
          $0["onFlight"] = onFlightPackets
          $0["availableBuf"] = availableBufferInBytes.formattedSize
        }
      }
    }

    init(nativeValue: CBytePerfMon) {
      packetSendingPeriod = Duration.microseconds(Double(nativeValue.usPktSndPeriod))
      flowWindowSizeInPackets = Int(nativeValue.pktFlowWindow)
      congestionWindowSizeInPackets = Int(nativeValue.pktCongestionWindow)
      onFlightPackets = Int(nativeValue.pktFlightSize)
      rtt = Duration.milliseconds(Double(nativeValue.msRTT))
      bandwidth = Int(nativeValue.mbpsBandwidth * megabits)
      availableBufferInBytes = .init(
        send: Int(nativeValue.byteAvailSndBuf),
        receive: Int(nativeValue.byteAvailRcvBuf),
      )
    }
  }
}

extension Statistics {
  public enum LogContextSubject {
    case instantaneous
    case total
  }
  public func logContext(for subject: LogContextSubject) -> LogContext {
    switch subject {
    case .instantaneous: logContextForInstantaneousMetrics()
    case .total: logContextForTotalMetrics()
    }
  }

  func logContextForInstantaneousMetrics() -> LogContext {
    LogContext {
      $0["measurement"] = instantaneousMeasurements.logContext
      $0["pck"] = packets.logContext
      $0["pckLost"] = packetsLost.logContext
      $0["pckDrop"] = packetsDropped.logContext
      $0["bandwidth"] = bandwidths.formattedBandwidth
      $0["uniquePck"] = uniquePackets.logContext
    }
  }

  func logContextForTotalMetrics() -> LogContext {
    LogContext {
      $0["duration"] = duration.formattedMilliseconds
      $0["pck"] = totalPackets.logContext
      $0["pckLost"] = totalPacketsLost.logContext
      $0["pckDrop"] = totalPacketsDropped.logContext
      $0["bytes"] = totalBytes.formattedSize
      $0["bytesLost"] = totalReceivedBytesLost.formattedSize
      $0["uniquePck"] = totalUniquePackets.logContext
    }
  }
}
extension Statistics.SendingReceivingDuration: LogContextReading {
  public var logContext: LogContext {
    LogContext {
      $0["send"] = send.formatted()
      $0["receive"] = receive.formatted()
    }
  }

  public var formattedMilliseconds: LogContext {
    LogContext {
      $0["send"] = send.formattedMilliseconds
      $0["receive"] = receive.formattedMilliseconds
    }
  }
}

extension Statistics.SendingReceiving: LogContextReading where T: BinaryInteger {
  public var logContext: LogContext {
    LogContext {
      $0["send"] = send.formatted()
      $0["receive"] = receive.formatted()
    }
  }

  public var formattedSize: LogContext {
    LogContext {
      $0["send"] = send.formattedSize
      $0["receive"] = receive.formattedSize
    }
  }

  public var formattedBandwidth: LogContext {
    LogContext {
      $0["send"] = send.formattedBandwidth
      $0["receive"] = receive.formattedBandwidth
    }
  }
}

extension Statistics.SendingReceiving where T == Double {

  public var formattedSize: LogContext {
    LogContext {
      $0["send"] = send.formattedSize
      $0["receive"] = receive.formattedSize
    }
  }

  public var formattedBandwidth: LogContext {
    LogContext {
      $0["send"] = send.formattedBandwidth
      $0["receive"] = receive.formattedBandwidth
    }
  }
}
