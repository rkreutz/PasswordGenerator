import SwiftUI

extension ContentSizeCategory {

    var modifier: CGFloat {

        switch self {

        case .extraSmall,
             .small:
            return 0.8

        case .medium,
             .large,
             .extraLarge:
            return 1

        case .extraExtraLarge,
             .extraExtraExtraLarge:
            return 1.2

        case .accessibilityMedium,
             .accessibilityLarge:
            return 1.5

        case .accessibilityExtraLarge:
            return 2.0

        case .accessibilityExtraExtraLarge:
            return 2.25

        case .accessibilityExtraExtraExtraLarge:
            return 2.5

        @unknown default:
            return 1
        }
    }
}
