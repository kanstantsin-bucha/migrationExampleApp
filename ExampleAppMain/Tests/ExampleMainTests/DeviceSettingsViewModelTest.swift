import XCTest
import ExampleMain

class DeviceSettingsViewModelTest: XCTestCase {
    private var viewModel: DeviceSettingsViewModel!
    private var mockDevicePersistence: MockDevicePersistence!
    private let deviceID = UUID().uuidString
    
    override func setUpWithError()throws {
        viewModel = DeviceSettingsViewModel(deviceID: deviceID)
        mockDevicePersistence = MockDevicePersistence()
        ExampleMain.add(servicesList: [(mockDevicePersistence, DevicePersistence.self)])
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDevicePersistence = nil
        removeAllServices()
    }
    
    func testDeviceLoadAndSync() {
        let device = anyDevice(id: deviceID)
        mockDevicePersistence.loadResult = device
        
        viewModel.onViewWillAppear()
        XCTAssertEqual(mockDevicePersistence.loadParams, deviceID)
        XCTAssertEqual(mockDevicePersistence.loadCount, 1)
        
        viewModel.syncDevice(name: "Test Name")
        
        XCTAssertEqual(mockDevicePersistence.saveParams?.id, deviceID)
        XCTAssertEqual(mockDevicePersistence.saveParams?.name, "Test Name")
        XCTAssertEqual(mockDevicePersistence.saveCount, 1)
    }
    
    // MARK: - Helpers
    
    func anyDevice(id: String) -> Device {
        Device(id: id, name: "name", token: "token", date: Date())
    }
}
