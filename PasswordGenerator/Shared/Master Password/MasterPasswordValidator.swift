import Dependencies
import Foundation

protocol MasterPasswordValidator {
    var hasMasterPassword: Bool { get }
}

private enum MasterPasswordValidatorKey: DependencyKey {
    static let liveValue: MasterPasswordValidator = MasterPasswordKeychain.shared
#if DEBUG
    static let previewValue: MasterPasswordValidator = false
    static let testValue: MasterPasswordValidator = false
#endif
}

extension DependencyValues {
    var masterPasswordValidator: MasterPasswordValidator {
        get { self[MasterPasswordValidatorKey.self] }
        set { self[MasterPasswordValidatorKey.self] = newValue }
    }
}

#if DEBUG
extension Bool: MasterPasswordValidator {
    var hasMasterPassword: Bool { self }
}
#endif
