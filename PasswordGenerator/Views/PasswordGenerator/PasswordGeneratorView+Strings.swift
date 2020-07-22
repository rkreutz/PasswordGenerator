import SwiftUI

extension Strings {

    enum PasswordGeneratorView {

        static let resetMasterPassword = LocalizedStringKey("Logout")

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

        static let generatePassword = LocalizedStringKey("Generate password")
    }
}
