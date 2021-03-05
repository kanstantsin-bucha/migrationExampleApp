//
//  BleCoreGate.swift
//  client
//
//  Created by Kanstantsin Bucha on 1.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

public protocol BleTransmitter {
    /// Sets state of a network adapter on the peripheral
    /// - Parameter isEnabled: The network adapter is on when true
    func requestSetWifiState(isEnabled: Bool) throws
    
    /// Sets ssid and pass for the pheripher to connect
    /// - Parameters:
    ///   - ssid: The string with the network name to connect. Max 16 chars
    ///   - pass: The string with the pass to connect. Max 16 chars
    func requestSetWifiCreds(
        ssid: String,
        pass: String
    ) throws
    
    /// Requests current connection info 
    func requestGetWifiNetworkInfo() throws
}
