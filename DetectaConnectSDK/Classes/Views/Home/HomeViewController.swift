//
//  HomeViewController.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var devices: UICollectionView!
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
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == View.a.Home.SegueId.toContext {
            let contextViewController = segue.destination as! ContextViewController
            contextViewController.token = sender as? String
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
            sender: cell.token
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
        
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        cell.update(withDevice: devicesList[indexPath.row])
        return cell
    }
}
