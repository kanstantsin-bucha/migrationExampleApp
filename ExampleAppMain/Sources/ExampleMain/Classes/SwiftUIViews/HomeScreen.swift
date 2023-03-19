import SwiftUI

struct HomeScreen: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController
    private let viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> HomeViewController {
        UIStoryboard(name: "Views", bundle: ExampleApp.assetsBundle)
            .instantiateViewController(identifier: ViewType.a.Home.id) {
                    HomeViewController(coder: $0, model: viewModel)
            }
    }
}
