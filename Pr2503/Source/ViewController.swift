import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets and IBActions

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bruteForceButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var stopButton: UIButton!

    // MARK: - Properties

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    var crackedPassword: String = "" {
        didSet {
            self.label.text = crackedPassword
        }
    }

    let bruteForceOperation = BruteForceOperation()

    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func changeBackgroundColor(_ sender: Any) {
        isBlack.toggle()
    }

    @IBAction func startBruteForce() {
        self.indicator.startAnimating()
        let secretPassword = self.textField.text ?? ""
        var result: String = ""

        bruteForceOperation.passwordToUnlock = secretPassword

        let queue = OperationQueue()

        let resultAssignmentBlockOperation = BlockOperation {
            result = self.bruteForceOperation.result
        }

        let showResultBlockOperation = BlockOperation {
            DispatchQueue.main.async {
                self.textField.isSecureTextEntry = false
                if result != "" {
                    self.crackedPassword = result
                } else {
                    self.crackedPassword = "Пароль \(secretPassword) не взломан."
                }
                self.indicator.stopAnimating()
            }
        }
        resultAssignmentBlockOperation.addDependency(bruteForceOperation)
        showResultBlockOperation.addDependency(resultAssignmentBlockOperation)
        queue.addOperations([bruteForceOperation, resultAssignmentBlockOperation, showResultBlockOperation], waitUntilFinished: false)
    }

    @IBAction func stopBruteForce() {
        self.bruteForceOperation.cancel()
        self.indicator.stopAnimating()
    }
}
