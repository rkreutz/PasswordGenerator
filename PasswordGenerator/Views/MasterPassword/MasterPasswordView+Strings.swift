//swiftlint:disable line_length
import SwiftUI

extension Strings {

    enum MasterPasswordView {

        static let title = LocalizedStringKey(
            """
            Set a Master Password so we can generate passwords from it.

            This should be the most secure as possible and you should remember it so in case you loose your device you might re-generate your passwords from another one.
            """
        )

        static let placeholder = LocalizedStringKey("Master password")

        static let save = LocalizedStringKey("Save")
    }
}
