import Combine
import Dependencies
import Foundation
import PasswordGeneratorKit

protocol AppConfigurationStorage: AnyObject {

    var shouldShowPasswordStrength: Bool { get set }

    func configurationChanges() -> AnyPublisher<AppConfigurationStorageChange, Never>
}

enum AppConfigurationStorageChange {
    case shouldShowPasswordStrength(Bool)
}

private enum AppConfigurationStorageKey: DependencyKey {
    static let liveValue: AppConfigurationStorage = UbiquitousAppConfigurationStorage(
        keyStore: .default,
        notificationCenter: .default
    )
#if DEBUG
    static let previewValue: AppConfigurationStorage = MockAppConfigurationStorage()
    static let testValue: AppConfigurationStorage = MockAppConfigurationStorage()
#endif
}

extension DependencyValues {
    var appConfigurationStorage: AppConfigurationStorage {
        get { self[AppConfigurationStorageKey.self] }
        set { self[AppConfigurationStorageKey.self] = newValue }
    }
}

#if DEBUG

final class MockAppConfigurationStorage: AppConfigurationStorage {

    var shouldShowPasswordStrength: Bool = false

    func configurationChanges() -> AnyPublisher<AppConfigurationStorageChange, Never> { Empty().eraseToAnyPublisher() }
}

#endif
