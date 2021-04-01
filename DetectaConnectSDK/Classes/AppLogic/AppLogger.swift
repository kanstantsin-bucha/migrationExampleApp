//
//  AppLogger.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

let log = Logger()

struct Logger {
    func error(_ error: Error) {
        printLog(error.localizedDescription, level: .error)
    }
    
    func error(_ message: String) {
        printLog(message, level: .error)
    }
    
    func warning(_ message: String) {
        printLog(message, level: .warning)
    }
    
    func debug(_ message: String) {
        printLog(message, level: .debug)
    }
    
    // MARK: - here are user actions
    
    func user(_ message: String) {
        printLog(message, level: .userAction)
    }
    
    func event(_ message: String) {
        printLog(message, level: .event)
    }
    
    // MARK: - here are operations
    
    func operation(_ message: String) {
        printLog(message, level: .operation)
    }
    
    func success(_ message: String) {
        printLog(message, level: .success)
    }
    
    func failure(_ message: String) {
        printLog(message, level: .failure)
    }
    
    func cancel(_ message: String) {
        printLog(message, level: .cancel)
    }
    
    // MARK: - Private methods
    
    private func printLog(_ message: String, level: LogType) {
        switch level {
        case LogType.error:
            print("⛔️ \(message)")
            
        case LogType.warning:
            print("🔔 \(message)")
        
        case LogType.debug:
            print("ℹ️ \(message)")
            
        // -/ here are user actions /-
        
        case LogType.userAction:
            print("😃 \(message)")
            
        case LogType.event:
            print("📢 \(message)")
            
        // -/ here are operations /-
            
        case LogType.operation:
            print("🔳 \(message)")
            
        case LogType.success:
            print("🟩 \(message)")
            
        case LogType.failure:
            print("🟥 \(message)")
            
        case LogType.cancel:
            print("⬜️ \(message)")
        }
    }
}

fileprivate enum LogType {
    case error
    case warning
    case debug
    
    // -/ here are user actions /-
    
    case userAction
    case event
    
    // -/ here are operations /-
    
    case operation
    case success
    case failure
    case cancel
}
