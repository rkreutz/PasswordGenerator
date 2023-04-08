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
            """
        )
        static let keyDerivationTitle = LocalizedStringKey("Key Derivation")
        static let pbkdfTitle = LocalizedStringKey("PBKDF2")
        static let argonTitle = LocalizedStringKey("Argon2")
        static let iterationsTitle = LocalizedStringKey("Iterations")
        static let memoryTitle = LocalizedStringKey("Memory (kB)")
        static let threadsTitle = LocalizedStringKey("Threads")
        static let entropySizeTitle = LocalizedStringKey("Entropy size (bytes)")
    }
}
