import Combine
import ComposableArchitecture
import Foundation
import PasswordGeneratorKit

final class UbiquitousAppConfigurationStorage: AppConfigurationStorage {

    enum Constants {
        static let shouldShowPasswordStrengthKey = "should_show_password_strength"
    }

    var shouldShowPasswordStrength: Bool {
        get {
            keyStore.bool(forKey: Constants.shouldShowPasswordStrengthKey)
        }
        set {
            keyStore.set(newValue, forKey: Constants.shouldShowPasswordStrengthKey)
        }
    }

    private let keyStore: NSUbiquitousKeyValueStore
    private let notificationCenter: NotificationCenter

    init(
        keyStore: NSUbiquitousKeyValueStore,
        notificationCenter: NotificationCenter
    ) {
        self.keyStore = keyStore
        self.notificationCenter = notificationCenter
        keyStore.synchronize()
    }

    func configurationChanges() -> AnyPublisher<AppConfigurationStorageChange, Never> {
        notificationCenter.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .flatMap { [unowned self] notification -> AnyPublisher<AppConfigurationStorageChange, Never> in
                guard
                    notification.userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int == NSUbiquitousKeyValueStoreServerChange,
                    let keys = notification.userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String]
                else { return Empty().eraseToAnyPublisher() }

                let shouldShowPasswordStrengthPublisher: AnyPublisher<AppConfigurationStorageChange, Never>
                if keys.contains(Constants.shouldShowPasswordStrengthKey) {
                    shouldShowPasswordStrengthPublisher = Just(.shouldShowPasswordStrength(shouldShowPasswordStrength)).eraseToAnyPublisher()
                } else {
                    shouldShowPasswordStrengthPublisher = Empty().eraseToAnyPublisher()
                }

                return shouldShowPasswordStrengthPublisher
            }
            .eraseToAnyPublisher()
    }
}
