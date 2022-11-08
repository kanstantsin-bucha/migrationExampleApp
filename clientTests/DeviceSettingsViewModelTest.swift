//
//  DeviceSettingsViewModelTest.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 04/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import XCTest
import DetectaConnect

class DeviceSettingsViewModelTest: XCTestCase {
    private var viewModel: DeviceSettingsViewModel!
    private var mockDeviceContainer: MockDeviceContainer!
    private var mockDevicePersistence: MockDevicePersistence!
    
    override func setUpWithError()throws {
        
        mockDeviceContainer = MockDeviceContainer()
        viewModel = DeviceSettingsViewModel(deviceContainer: mockDeviceContainer)
        mockDevicePersistence = MockDevicePersistence()
        DetectaConnect.add(servicesList: [(mockDevicePersistence, DevicePersistence.self)])
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDevicePersistence = nil
        removeAllServices()
    }
    
    func testDeviceSync() {
        
        // Arrange
        mockDeviceContainer.deviceResult = Device(
            id: "id",
            name: "Mock Test",
            token: "123",
            date: Date())
        
        // Act
        viewModel.syncDevice(name: "Test Name")
        
        // Assert
        XCTAssertEqual(mockDeviceContainer.clearCacheCount, 1)
        XCTAssertEqual(mockDevicePersistence.saveParams?.id, "id")
        XCTAssertEqual(mockDevicePersistence.saveParams?.name, "Test Name")
        XCTAssertEqual(mockDevicePersistence.saveParams?.token, "123")
        
    }
}
