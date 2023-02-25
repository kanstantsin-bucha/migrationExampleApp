import UIKit
import Combine

final class SetupGadgetViewController: UIViewController {
    @IBOutlet var ssidField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    private var isPendingConnection = false
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    private let model: SetupGadgetViewModel = SetupGadgetViewModel()
    
    // MARK: - Actions
    
    @IBAction func goButtonDidTouch(sender: UIButton) {
        startSetup()
    }
    
    @objc func viewDidLongPress(sender: UILongPressGestureRecognizer) {
        guard goButton.isEnabled else { return }
        // MARK: - Development purposes only
        let alert = UIAlertController(title: "Set Default", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Default", style: .default) { _ in
            self.model.setupDevice(ssid: "sdfasdfsdf", pass: "asdfsadfsdf")
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressGestureRecognizer.addTarget(self, action: #selector(viewDidLongPress(sender:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.stateSubject.subscribe { [weak self] state in
            onMain {
                log.event("update state: \(state)")
                guard let self = self else { return }
                
                switch state {
                case .connecting:
                    self.view.isUserInteractionEnabled = false
                    service(GatesKeeper.self).bleGate.open()
                    self.goButton.isEnabled = false
                    service(AppRouter.self).showSpinner()
                    self.ssidField.resignFirstResponder()
                    self.passField.resignFirstResponder()
                    
                case .connected:
                    self.view.isUserInteractionEnabled = true
                    self.goButton.isEnabled = true
                    service(AppRouter.self).hideSpinner()
                    self.ssidField.becomeFirstResponder()
                    
                case .settingUp:
                    self.view.isUserInteractionEnabled = false
                    self.goButton.isEnabled = false
                    service(AppRouter.self).showSpinner()
                    self.ssidField.resignFirstResponder()
                    self.passField.resignFirstResponder()
                    
                case .setUp:
                    self.view.isUserInteractionEnabled = true
                    // some logic moved from here to viewDidDisappear
                    if let navigation = self.navigationController {
                        navigation.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        model.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        model.stateSubject.cancel()
        service(AppRouter.self).hideSpinner()
        service(GatesKeeper.self).bleGate.close()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private methods
    
    private func startSetup() {
        model.setupDevice(
            ssid: ssidField.text ?? "",
            pass: passField.text ?? ""
        )
    }
}

extension SetupGadgetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField is ActionTextField {
            startSetup()
        }
        return true
    }
}
