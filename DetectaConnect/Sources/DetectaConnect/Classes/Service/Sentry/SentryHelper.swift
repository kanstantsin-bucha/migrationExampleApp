//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 30/04/2022.
//

import Foundation
import Sentry

struct SentryHelper {
    static func transaction(_ message: String, startTimestamp: Date = Date()) {
        let event = Event()
        event.eventId = SentryId()
        event.message = SentryMessage(formatted: message)
        event.startTimestamp = startTimestamp
        event.type = "transaction"
        event.transaction = "Local"
        SentrySDK.capture(event: event)
    }
    
    static func error(_ message: String) {
        SentrySDK.capture(message: message)
    }
}
