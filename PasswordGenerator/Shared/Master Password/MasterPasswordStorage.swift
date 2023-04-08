import Dependencies
import Foundation

protocol MasterPasswordStorage {

    func save(masterPassword: String) throws

    func masterPassword() throws -> String

    func deleteMasterPassword() throws
}

private enum MasterPasswordStorageKey: DependencyKey {
    static let liveValue: MasterPasswordStorage = MasterPasswordKeychain.shared
    #if DEBUG
    static let previewValue: MasterPasswordStorage = MockMasterPasswordStorage()
    static let testValue: MasterPasswordStorage = MockMasterPasswordStorage()
    #endif
}

extension DependencyValues {
    var masterPasswordStorage: MasterPasswordStorage {
        get { self[MasterPasswordStorageKey.self] }
        set { self[MasterPasswordStorageKey.self] = newValue }
    }
}

#if DEBUG

import PasswordGeneratorKit

final class MockMasterPasswordStorage: MasterPasswordStorage, MasterPasswordProvider {

    fileprivate var _masterPassword: String = "masterPassword"

    func save(masterPassword: String) throws { _masterPassword = masterPassword }
    func masterPassword() throws -> String { _masterPassword }
    func deleteMasterPassword() throws { _masterPassword = "" }
}

extension MockMasterPasswordStorage: MasterPasswordValidator {

    var hasMasterPassword: Bool { _masterPassword.isEmpty == false }
}

#endif
