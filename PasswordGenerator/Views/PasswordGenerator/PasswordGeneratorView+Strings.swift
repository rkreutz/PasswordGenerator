import SwiftUI

extension Strings {

    enum PasswordGeneratorView {

        static let resetMasterPassword = LocalizedStringKey("Logout")

        static let passwordType = LocalizedStringKey("Type")

        static let domainBased = LocalizedStringKey("Domain")
        static let serviceBased = LocalizedStringKey("Service")

        static let username = LocalizedStringKey("Username/Email")
        static let domain = LocalizedStringKey("Website URL")
        static let seed = LocalizedStringKey("Seed")

        static let service = LocalizedStringKey("Service")

        static let passwordLength = LocalizedStringKey("Password length")

        static let lowercasedCharacters = LocalizedStringKey("abc...")
        static let uppercasedCharacters = LocalizedStringKey("ABC...")
        static let decimalCharacters = LocalizedStringKey("123...")
        static let symbolsCharacters = LocalizedStringKey("!@#...")
        static let numberOfCharacters = LocalizedStringKey("Number of characters")

        static let lowercasedCharactersTooltip = LocalizedStringKey("Whether password should include lowercase characters, and how many.")
        static let uppercasedCharactersTooltip = LocalizedStringKey("Whether password should include uppercase characters, and how many.")
        static let decimalCharactersTooltip = LocalizedStringKey("Whether password should include numbers, and how many.")
        static let symbolsCharactersTooltip = LocalizedStringKey("Whether password should include special characters, and how many.")

        static let generatePassword = LocalizedStringKey("Generate password")
    }
}
