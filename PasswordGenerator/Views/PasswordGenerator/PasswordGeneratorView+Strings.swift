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

        static let passwordStrengthTitle = LocalizedStringKey("Password Strength")
        static let passwordStrengthTooltip = LocalizedStringKey(
            """
            The strength of the password given the amount of bits of entropy it has. \
            This can be calculated by log2(character_set_length) * number_of_characters. \
            The higher it is, the more compute power is needed to brute force the password.
            """
        )

        static func veryWeakPassword(_ arg: Int) -> LocalizedStringKey { "Very Weak (\(arg) bits)" }
        static func weakPassword(_ arg: Int) -> LocalizedStringKey { "Weak (\(arg) bits)" }
        static func recommendedPassword(_ arg: Int) -> LocalizedStringKey { "Strong (\(arg) bits)" }
        static func veryStrongPassword(_ arg: Int) -> LocalizedStringKey { "Very Strong (\(arg) bits)" }

        static let entropyGeneratorOverflowTitle = LocalizedStringKey("Entropy Limit Reached")
        static let entropyGeneratorOverflowTooltip = LocalizedStringKey(
            """
            Your password is too long for the entropy source, therefore the real entropy \
            of your password is limited by the entropy source's size. You may fix this \
            by increasing the entropy size in Settings.
            """
        )

        static let generatePassword = LocalizedStringKey("Generate password")
    }
}
