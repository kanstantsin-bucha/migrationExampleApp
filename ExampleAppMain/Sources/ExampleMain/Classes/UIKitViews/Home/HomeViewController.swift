import UIKit

class HomeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    @IBOutlet var devicesCollectionView: UICollectionView!
    @IBOutlet weak var plusButton: UIButton!
    private let model: HomeViewModel
    private var devices = [Device]()
    
    public init?(coder: NSCoder, model: HomeViewModel) {
        self.model = model
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        model.onViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Private methods
    
    private func configure() {
        model.observeDevices = { [weak self] devices in
            onMain {
                self?.devices = devices
                self?.devicesCollectionView.reloadData()
            }
        }
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let delete = UIContextualAction(
                style: .destructive,
                title: "Delete"
            ) { [weak self] _, _, completion in
                let index = indexPath.row
                guard let self, self.devices.count > index else {
                    completion(false)
                    return
                }
                let device = self.devices[index]
                self.model.delete(device: device)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [delete])
        }
        devicesCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        devicesCollectionView.dataSource = self
        devicesCollectionView.delegate = self
        plusButton.setImage((#imageLiteral(resourceName: "plus-medium") as FrameworkAsset).image, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewType.a.Home.SegueId.toContext {
            guard let contextViewController = segue.destination as? ContextViewController,
                  let id = (sender as? DeviceCollectionViewCell)?.deviceId else {
                preconditionFailure(#fileID + "Conditions for segue aren't met: \(segue)")
            }
            contextViewController.viewModel = ContextViewModel(deviceID: id)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DeviceCollectionViewCell else {
            return
        }
        performSegue(
            withIdentifier: ViewType.a.Home.SegueId.toContext,
            sender: cell
        )
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = devicesCollectionView.dequeueReusableCell(
            withReuseIdentifier: "Device",
            for: indexPath
        ) as! DeviceCollectionViewCell
        
        cell.update(withDevice: devices[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 80)
    }
}
