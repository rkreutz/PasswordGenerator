import Foundation
import PasswordGeneratorKit

extension PasswordGeneratorView {

    struct ViewState: Equatable {

        var configurationState = ConfigurationState()
        var charactersState = CharactersState()
        var passwordState = PasswordState.invalid
        var error: Error?

        var rules: Set<PasswordRule> {

            var rules = Set([PasswordRule.length(charactersState.length)])

            if charactersState.numberOfDigits > 0 {

                rules.insert(.mustContainDecimalCharacters(atLeast: charactersState.numberOfDigits))
            }

            if charactersState.numberOfSymbols > 0 {

                rules.insert(.mustContainSymbolCharacters(atLeast: charactersState.numberOfSymbols))
            }

            if charactersState.numberOfLowercase > 0 {

                rules.insert(.mustContainLowercaseCharacters(atLeast: charactersState.numberOfLowercase))
            }

            if charactersState.numberOfUppercase > 0 {

                rules.insert(.mustContainUppercaseCharacters(atLeast: charactersState.numberOfUppercase))
            }
            
            return rules
        }

        var isValid: Bool { charactersState.isValid && charactersState.isValid }

        static func == (lhs: PasswordGeneratorView.ViewState, rhs: PasswordGeneratorView.ViewState) -> Bool {

            guard
                lhs.configurationState == rhs.configurationState,
                lhs.charactersState == rhs.charactersState,
                lhs.passwordState == rhs.passwordState
                else { return false }

            switch (lhs.error, rhs.error) {

            case (.some, .some),
                 (.none, .none):
                return true

            default:
                return false
            }
        }
    }
}
