//
//  BruteForceOperation.swift
//  Pr2503
//
//  Created by Admin on 19/05/2023.
//

import Foundation

class BruteForceOperation: Operation {

    // MARK: - Properties

    var passwordToUnlock: String = ""
    var result: String = ""

    // MARK: - Override main func

    override func main() {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""

        while password != passwordToUnlock {
            if self.isCancelled {
                return
            } else {
                password = generateBruteForce(password, fromArray: allowedCharacters)
                print(password)
            }
        }
        self.result = password
    }

    // MARK: - Functions

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
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
}
