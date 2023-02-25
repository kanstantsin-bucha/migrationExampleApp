import SwiftUI

struct HomeScreen: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> HomeViewController {
        ViewFactory.loadView(id: ViewType.a.Home.id)
    }
}
