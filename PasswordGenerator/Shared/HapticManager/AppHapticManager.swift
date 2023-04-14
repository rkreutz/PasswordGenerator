#if os(iOS)
import UIKit

final class AppHapticManager: HapticManager {

    func generateHapticFeedback(_ event: HapticEvent) {

        switch event {

        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()

        case let .impact(style, .none):
            UIImpactFeedbackGenerator(style: style.asFeedbackStyle()).impactOccurred()

        case let .impact(style, .some(intensity)):
            UIImpactFeedbackGenerator(style: style.asFeedbackStyle()).impactOccurred(intensity: CGFloat(intensity))

        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)

        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)

        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

private extension HapticEvent.ImpactStyle {

    func asFeedbackStyle() -> UIImpactFeedbackGenerator.FeedbackStyle {

        switch self {

        case .heavy: return .heavy
        case .light: return .light
        case .medium: return .medium
        case .rigid: return .rigid
        case .soft: return .soft
        }
    }
}

#elseif os(macOS)
import AppKit

final class AppHapticManager: HapticManager {

    func generateHapticFeedback(_ event: HapticEvent) {

        switch event {

        case .selection:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)

        case .impact:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)

        case .success:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)

        case .warning:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)

        case .error:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        }
    }
}

#endif
