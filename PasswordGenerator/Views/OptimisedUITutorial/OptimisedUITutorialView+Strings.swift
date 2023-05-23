import SwiftUI

extension Strings {
    enum OptimisedUITutorialView {
        static let characterFamily = LocalizedStringKey("abc...")
        static let charactersViewStep1 = LocalizedStringKey("""
            This is the new character selection button.

            If tapped, the character family represented by it will be included on your password.
            """
        )
        static let charactersViewStep2 = LocalizedStringKey(
            "Now try a long press on the button to change how many characters should be included."
        )
        static let charactersViewStep3 = LocalizedStringKey("""
            Well done!

            Now tap on the button again to unselect this character family.
            """
        )
    }
}
