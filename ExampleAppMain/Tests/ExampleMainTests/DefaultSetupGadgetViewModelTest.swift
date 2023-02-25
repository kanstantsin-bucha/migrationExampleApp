import ExampleMain
import XCTest

class DefaultSetupGadgetViewModelTest: XCTestCase {
    
    private var setupGadgetViewModel: SetupGadgetViewModel!
    private var mockGadgetSetupInteractor: MockGadgetSetupInteractor!
    private var mockAlertRouter: MockAlertRouter!
    
    override func setUpWithError() throws {
        setupGadgetViewModel = SetupGadgetViewModel(secondsToRepeat: 0)
        mockAlertRouter = MockAlertRouter()
        mockGadgetSetupInteractor = MockGadgetSetupInteractor()
        ExampleMain.add(servicesList: [
            (mockGadgetSetupInteractor, GadgetSetupInteractor.self),
            (mockAlertRouter, AlertRouter.self)
        ])
    }
    
    override func tearDownWithError() throws {
        setupGadgetViewModel = nil
        mockAlertRouter = nil
        mockGadgetSetupInteractor = nil
        ExampleMain.removeAllServices()
    }
    
    func testSetupDeviceSucceed() throws {
        
        //Given
        mockGadgetSetupInteractor.connectBleDeviceWifiResult = .success(())
        var finalState = SetupGadgetViewModel.ViewState.connected
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //When
        setupGadgetViewModel.setupDevice(ssid: "123", pass: "321")
        
        //Then
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "123")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "321")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .setUp)
    }
    
    func testSetupDeviceFailedConnecting() throws {
        
        //Given
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [false]
        var finalState = SetupGadgetViewModel.ViewState.setUp
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //When
        setupGadgetViewModel.setupDevice(ssid: "Ss12", pass: "@3d")
        
        //Then
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "Ss12")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "@3d")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .connecting)
        XCTAssertEqual(mockAlertRouter.showErrorCounter, 1)
    }
    
    func testSetupDeviceFailedConnected() throws {
        
        //Given
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [true]
        var finalState = SetupGadgetViewModel.ViewState.setUp
        setupGadgetViewModel.stateSubject.subscribe { state in
            finalState = state
        }
        
        //When
        setupGadgetViewModel.setupDevice(ssid: "234", pass: "678")
        
        //Then
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.ssid, "234")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiParams?.pass, "678")
        XCTAssertEqual(mockGadgetSetupInteractor.connectBleDeviceWifiCount, 1)
        XCTAssertEqual(finalState, .connected)
        XCTAssertEqual(mockAlertRouter.showErrorCounter, 1)
    }
    
    func testThatCheckDeviceWillRepeatAfterFailure() {
        //Given
        mockGadgetSetupInteractor.checkConnectedDeviceResults = [false, true]
        var states: [SetupGadgetViewModel.ViewState] = []
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
