//
//  HomeViewController.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class HomeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    @IBOutlet var devices: UICollectionView!
    @IBOutlet weak var plusButton: UIButton!
    private var devicesList: [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        devicesList = service(DevicePersistence.self).loadAll()
        devices.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Private methods
    
    private func configure() {
        devices.dataSource = self
        devices.delegate = self
        plusButton.setImage((#imageLiteral(resourceName: "plus-medium") as FrameworkAsset).image, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == View.a.Home.SegueId.toContext {
            guard let contextViewController = segue.destination as? ContextViewController,
                  let id = (sender as? DeviceCollectionViewCell)?.deviceId else {
                preconditionFailure(#fileID + "Conditions for segue aren't met: \(segue)")
            }
            contextViewController.apply(deviceContainer: DeviceContainer(deviceId: id))
        }
        if segue.identifier == View.a.SetupGadget.id {
            guard let viewController = segue.destination as? SetupGadgetViewController else {
                preconditionFailure(#fileID + "Conditions for segue aren't met: \(segue)")
            }
            viewController.model = DefaultSetupGadgetViewModel()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DeviceCollectionViewCell else {
            return
        }
        performSegue(
            withIdentifier: View.a.Home.SegueId.toContext,
            sender: cell
        )
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = devices.dequeueReusableCell(
            withReuseIdentifier: "Device",
            for: indexPath
        ) as! DeviceCollectionViewCell
        
        cell.contentView.layer.borderColor = UIColor.frameworkAsset(named: "AirBlue").cgColor
        cell.update(withDevice: devicesList[indexPath.row])
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