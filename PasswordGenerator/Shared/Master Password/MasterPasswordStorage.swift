import Foundation

protocol MasterPasswordStorage {

    func save(masterPassword: String) throws

    func masterPassword() throws -> String

    func deleteMasterPassword() throws
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
