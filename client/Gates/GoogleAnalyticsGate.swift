//
//  GoogleAnalyticsGate.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 1/10/19.
//  Copyright © 2019 Qroma LLC. All rights reserved.
//

import Foundation

enum GoogleAnalyticsGateError: Error {
    case invalidIdentifier(desc: String)
    case invalidShared(desc: String)
    case invalidTracker(desc: String)
}


protocol AnalyticsGate: GateKeeper {
    func trackEvent(category: String,
                    action: String,
                    label: String,
                    value: NSNumber)
}


class GoogleAnalyticsGate: AnalyticsGate {
    
    var isOpen = false
    
    func summon(
        infoDictionary: [String : Any]?,
        launchOptions: [AnyHashable : Any]?
    ) throws {
        
//        let google = infoDictionary?["Google"] as? NSDictionary
//        let identifier = google?["GA-TrackingID"] as? String
//        guard let validIdentifier = identifier else {
//            let desc = "[Error]: Failed to read Google Analytics identifier from the info.plist file (Google->GA-TrackingID)"
//            throw GoogleAnalyticsGateError.invalidIdentifier(desc: desc)
//        }
//        guard let gai = GAI.sharedInstance() else {
//            let desc = "[Error]: Google Analytics not configured correctly"
//            throw GoogleAnalyticsGateError.invalidShared(desc: desc)
//        }
//
//        tracker = gai.tracker(withTrackingId: validIdentifier)
//        gai.trackUncaughtExceptions = true
    }
    
    func open() throws {
//        guard tracker != nil else {
//            let desc = "[Error]: Google Analytics has no configured tracker"
//            throw GoogleAnalyticsGateError.invalidTracker(desc: desc)
//        }
        isOpen = true
    }
    
    func close() {
        isOpen = false
    }
    
    // MARK - tracking
    
    func trackEvent(category: String,
                      action: String,
                       label: String,
                       value: NSNumber) {
        
        guard isOpen else {
            
            return
        }
        
      
        guard let validDict = [:] as? [AnyHashable : Any] else {
            print("""
                [Error]: ActionTracker:
                category: \(category)
                action: \(category)
                label: \(category)
                value: \(value)
                """);
            print("[Error]: ActionTracker: failed to create event dictionary");
            return
        }
    
    }
    
    private func readableActions(from action: String) -> [String] {
        
        let actionDesc = "\(action)"
        
        let actions = actionDesc.split(separator: "(").map{ String($0) }
        
        var result: [String] = []
        
        for action in actions {
            let subactions = action.split(separator: ".").map{ String($0) }
            let clearAction = subactions.last?.replacingOccurrences(of: ")", with: "")
            guard let validAction = clearAction else {
                continue
            }
            result.append(validAction)
        }
        
        print(result)
        return result
    }
}
