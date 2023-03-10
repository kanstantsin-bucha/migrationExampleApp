import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var title: UILabel!
    private(set) var deviceId: String?
    
    func update(withDevice device: Device) {
        deviceId = device.id
        title.text = device.name
    }
}
