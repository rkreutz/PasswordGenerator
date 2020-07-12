import SwiftUI

protocol MasterPasswordValidator {

    var hasMasterPassword: Bool { get }
}

#if DEBUG

final class MockPasswordValidator: MasterPasswordValidator {

    var hasMasterPassword: Bool { true }
}

#endif
