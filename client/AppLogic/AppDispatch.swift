//
//  AppDispatch.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

typealias EmptyClosure = () -> Void

func onMain(afterSeconds: Int, closure: @escaping EmptyClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(afterSeconds)) {
        closure()
    }
}

func onMain(closure: @escaping EmptyClosure) {
    guard Thread.current.isMainThread else {
        DispatchQueue.main.async {
            closure()
        }
        return
    }
    closure()
}
