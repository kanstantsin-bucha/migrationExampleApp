import Foundation

public protocol BleTransmitter {
    var isConnecting: Bool { get }
    
    /// Setups device using connect info
    /// - Parameters:
    ///   - ssid: The string with the network name to connect. Max 16 chars
    ///   - pass: The string with the pass to connect. Max 16 chars
    func requestSetup(
        ssid: String,
        pass: String
    ) throws
}
