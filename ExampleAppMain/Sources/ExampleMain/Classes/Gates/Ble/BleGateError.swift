import Foundation

enum BleGateError: Error {
    case notConnected
    case incosistentData
    case writeFailed
    case protobufEncoding(error: Error)
}

extension BleGateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notConnected:
            return "Pheripheral is not connected"
        case .incosistentData:
            return "The data is inconsisten"
        case .writeFailed:
            return "The data write operation failed"
        case .protobufEncoding(let error):
            return "The protobuf message encoding failed: \(error.localizedDescription)"
        }
    }
}
