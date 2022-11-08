//
//  DefaultSetupGadgetViewModelTest.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 20/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnect
import XCTest

class DefaultSetupGadgetViewModelTest: XCTestCase {
    
    private var setupGadgetViewModel: DefaultSetupGadgetViewModel!
    private var mockGadgetSetupInteractor: MockGadgetSetupInteractor!
    private var mockAlertRouter: MockAlertRouter!
    
    override func setUpWithError() throws {
        setupGadgetViewModel = DefaultSetupGadgetViewModel(secondsToRepeat: 0)
        mockAlertRouter = MockAlertRouter()
        mockGadgetSetupInteractor = MockGadgetSetupInteractor()
        DetectaConnect.add(servicesList: [
            (mockGadgetSetupInteractor, GadgetSetupInteractor.self),
            (mockAlertRouter, AlertRouter.self)
        ])
    }
    
    override func tearDownWithError() throws {
        setupGadgetViewModel = nil
        mockAlertRouter = nil
        mockGadgetSetupInteractor = nil
        DetectaConnect.removeAllServices()
    }
    
    func testSetupDeviceSucceed() throws {
        
        //Arrange
        mockGadgetSetupInteractor.connectBleDeviceWifiResult = .success(())
        var finalState = SetupGadgetViewState.connected
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //Act
        setupGadgetViewModel.setupDevice(ssid: "123", pass: "321")
        
        //Asset
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "123")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "321")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .setUp)
    }
    
    func testSetupDeviceFailedConnecting() throws {
        
        //Arrange
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [false]
        var finalState = SetupGadgetViewState.setUp
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //Act
        setupGadgetViewModel.setupDevice(ssid: "Ss12", pass: "@3d")
        
        //Asset
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "Ss12")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "@3d")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .connecting)
        XCTAssertEqual(mockAlertRouter.showErrorCounter, 1)
    }
    
    func testSetupDeviceFailedConnected() throws {
        
        //Arrange
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [true]
        var finalState = SetupGadgetViewState.setUp
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //Act
        setupGadgetViewModel.setupDevice(ssid: "234", pass: "678")
        
        //Asset
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "234")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "678")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .connected)
        XCTAssertEqual(mockAlertRouter.showErrorCounter, 1)
    }
    
    func testThatCheckDeviceWillRepeatAfterFailure() {
        //Given
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [false, true]
        var states: [SetupGadgetViewState] = []
        setupGadgetViewModel.stateSubject.subscribe { state in
            states.append(state)
        }
       
        //When
        setupGadgetViewModel.setupDevice(ssid: "1", pass: "2")
        wait(
            for: [mockGadgetSetupInteractor.checkConnectedDeviceResultExpectation],
               timeout: 1
        )
        
        //Then
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "1")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "2")
        XCTAssertEqual(states, [.settingUp, .connecting, .connected])
    }
}
