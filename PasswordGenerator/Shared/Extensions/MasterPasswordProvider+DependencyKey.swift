import Dependencies
import Foundation
import PasswordGeneratorKit

private enum MasterPasswordProviderKey: DependencyKey {
    static let liveValue: MasterPasswordProvider = MasterPasswordKeychain.shared
#if DEBUG
    static let previewValue: MasterPasswordProvider = "MasterPassword"
    static let testValue: MasterPasswordProvider = "MasterPassword"
#endif
}

extension DependencyValues {
    var masterPasswordProvider: MasterPasswordProvider {
        get { self[MasterPasswordProviderKey.self] }
        set { self[MasterPasswordProviderKey.self] = newValue }
    }
}
