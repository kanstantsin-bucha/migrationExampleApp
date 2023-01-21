//
//  HomeScreen.swift
//  
//
//  Created by Kanstantsin Bucha on 21/01/2023.
//

import SwiftUI

struct HomeScreen: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> HomeViewController {
        ViewFactory.loadView(id: ViewType.a.Home.id)
    }
}
