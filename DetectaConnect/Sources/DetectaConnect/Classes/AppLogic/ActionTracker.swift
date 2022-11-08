//
//  ActionTracker.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/6/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//







//
//import Foundation
//
//protocol ActionTracker {
//    func user(action: UserAction)
//    func interface(action: InterfaceAction)
//    func data(action: DataAction)
//}
//
//class ActionTrackerImpl: ActionTracker {
//    
//    let analytics: AnalyticsGate
//    
//    init(with analytics: AnalyticsGate) {
//        self.analytics = analytics
//    }
//    
//    //MARK: - iterface -
//    
//    func user(action: UserAction) {
//        
//        let actions = readableActions(from: "\(action)")
//        
//        analytics.trackEvent(category: actions[safe: 0] ?? "",
//                             action: actions[safe: 1] ?? "",
//                             label: actions[safe: 2] ?? "",
//                             value: NSNumber(value: 0))
//    }
//    
//    func interface(action: InterfaceAction) {
//        
//        let actions = readableActions(from: "\(action)")
//        
//        let number = Float(actions[safe: 2] ?? "")
//        
//        analytics.trackEvent(category: "<Interface>",
//                             action: actions[safe: 0] ?? "",
//                             label: actions[safe: 1] ?? "",
//                             value: NSNumber(value: number ?? 0))
//    }
//    
//    func data(action: DataAction) {
//        
//        let actions = readableActions(from: "\(action)")
//        
//        analytics.trackEvent(category: "<Data>",
//                             action: actions[safe: 0] ?? "",
//                             label: actions[safe: 1] ?? "",
//                             value: NSNumber(value: 0))
//    }
//    
//    //MARK: - logic -
//    
//    private func readableActions(from action: String) -> [String] {
//        let actionDesc = "\(action)"
//        let actions = actionDesc.split(separator: "(").map{ String($0) }
//        var result: [String] = []
//        
//        for action in actions {
//            let subactions = action.split(separator: ".").map{ String($0) }
//            let clearAction = subactions.last?.replacingOccurrences(of: ")", with: "")
//            guard let validAction = clearAction else {
//                continue
//            }
//            result.append(validAction)
//        }
//        
//        print(result)
//        return result
//    }
//}
