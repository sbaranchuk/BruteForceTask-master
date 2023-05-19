import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets and IBActions

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generationButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBAction func changeBackgroundColor(_ sender: Any) {
        isBlack.toggle()
    }

    @IBAction func generatesPassword() {
        let countCharactersInPassword = 3
        let allowedCharacters: [String] = String().toGenerate.map { String($0) }
        let countAllowedCharacters = allowedCharacters.count
        var result = ""
        while result.count != countCharactersInPassword {
            result += allowedCharacters[Int.random(in: 0...countAllowedCharacters-1)]
        }
        self.textField.isSecureTextEntry = true
        setToTextfield(text: result)
        self.indicator.startAnimating()

        let queue = DispatchQueue(label: "bruteForce", qos: .default)
        queue.async {
            self.bruteForce(passwordToUnlock: result)
        }
    }

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
            self.textField.isSecureTextEntry = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
        }
        DispatchQueue.main.async {
            self.crackedPassword = password
            self.indicator.stopAnimating()
        }
    }

    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last ?? Character(""), array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? Character(""))
            }
        }
        return str
    }

    func setToTextfield(text: String) {
        self.textField.text = text
    }
}

