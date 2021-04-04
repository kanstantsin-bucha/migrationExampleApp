//
//  HomeViewController.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var devices: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private methods
    
    private func configure() {
        devices.dataSource = self
        devices.delegate = self
        devices.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: View.a.Home.SegueId.toContext, sender: self)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return devices.dequeueReusableCell(withReuseIdentifier: "Device", for: indexPath)
    }
}
