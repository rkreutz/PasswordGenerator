import Foundation

extension PasswordGeneratorView {

    struct CharactersState: Equatable {

        var length: Int = 8
        var numberOfDigits: Int = 1
        var numberOfSymbols: Int = 0
        var numberOfLowercase: Int = 1
        var numberOfUppercase: Int = 1

        var minimalLength: Int { max(numberOfDigits + numberOfSymbols + numberOfLowercase + numberOfUppercase, 4) }
        var isValid: Bool { (numberOfDigits + numberOfSymbols + numberOfLowercase + numberOfUppercase) > 0 }
    }
}
