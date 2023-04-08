import Dependencies
import Foundation

protocol HapticManager {
    func generateHapticFeedback(_ event: HapticEvent)
}

private enum HapticManagerKey: DependencyKey {
    static let liveValue: HapticManager = UIKitHapticManager()
}

extension DependencyValues {
    var hapticManager: HapticManager {
        get { self[HapticManagerKey.self] }
        set { self[HapticManagerKey.self] = newValue }
    }
}
