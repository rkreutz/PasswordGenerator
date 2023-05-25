//swiftlint:disable line_length
import SwiftUI

extension Strings {

    enum AppConfigurationView {

        static let clearMasterPasswordTitle = LocalizedStringKey("Reset Master Password")
        static let entropyConfigurationSectionTitle = LocalizedStringKey("Entropy Generator")
        static let entropyConfigurationSectionDescription = LocalizedStringKey(
            """
            The Entropy Generator is the source of the password generation process, this will take your Master Password and generate some pseudo-randomic large value from it which is then used to derive your passwords.

            It is recommended to use as large as possible values in most parameters, however increasing some parameters may increase processing times, therefore test your configuration before commiting to it and make sure you are happy with the time it takes to generate your passwords. In general the longer it takes to generate a password, the harder it is for hackers to brute-force it.

            The default generator is PBKDF2 with 1,000 iterations and 40 bytes of entropy.

            You may test your current configuration by profiling the entropy generator. It is \
            recommended that entropy generation times are at least 80ms and that generating \
            the password (which is the sum of entropy generation with the computation of the password) \
            takes almost the same time.
            """
        )
        static let profileGeneratorTitle = LocalizedStringKey("Profile Generator")
        static func passwordGeneratorProfilingResult(entropyGeneration: TimeInterval, total: TimeInterval) -> LocalizedStringKey {
            LocalizedStringKey(
                """
                Average Times
                Entropy Generation: \(entropyGeneration)s
                Generate Password (total): \(total)s
                """
            )
        }
        static let keyDerivationTitle = LocalizedStringKey("Key Derivation")
        static let pbkdfTitle = LocalizedStringKey("PBKDF2")
        static let argonTitle = LocalizedStringKey("Argon2")
        static let iterationsTitle = LocalizedStringKey("Iterations")
        static let memoryTitle = LocalizedStringKey("Memory (kB)")
        static let threadsTitle = LocalizedStringKey("Threads")
        static let entropySizeTitle = LocalizedStringKey("Entropy size (bytes)")
        static let appConfigTitle = LocalizedStringKey("General")
        static let useOptimisedUITitle = LocalizedStringKey("Use optimised UI")
        static let optimisedUITutorialTitle = LocalizedStringKey("Optimised UI Tutorial")
        static let showPasswordStrengthTitle = LocalizedStringKey("Show password strength")
        static let passwordStrengthFooter = LocalizedStringKey(
            """
            If enabled, a password strength indicator will be displayed along with \
            the generated password.

            The password strength is measured in bits of entropy, where a higher value \
            means it takes more compute power to brute force the generated password.

            Password entropy can be calculated with the following expression:
            log2(character_set_length) * number_of_characters
            """
        )
    }
}
