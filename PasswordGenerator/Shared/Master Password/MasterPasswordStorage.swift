import SwiftUI

protocol MasterPasswordStorage {

    func save(masterPassword: String) throws

    func masterPassword() throws -> String

    func deleteMasterPassword() throws
}

#if DEBUG

final class MockMasterPasswordStorage: MasterPasswordStorage {

    func save(masterPassword: String) throws {}
    func masterPassword() throws -> String { "masterPassword" }
    func deleteMasterPassword() throws {}
}

#endif
