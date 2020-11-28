import Foundation

extension MasterPasswordView {

    struct Environment {

        let masterPasswordStorage: MasterPasswordStorage
    }
}

// MARK: Factories

extension MasterPasswordView.Environment {

    static func live() -> Self {

        MasterPasswordView.Environment(masterPasswordStorage: MasterPasswordKeychain())
    }
}
