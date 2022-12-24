import Foundation

extension MasterPasswordView {

    struct Environment {

        let masterPasswordStorage: MasterPasswordStorage
    }
}

// MARK: Factories

extension MasterPasswordView.Environment {

    static func preview() -> Self {

        MasterPasswordView.Environment(masterPasswordStorage: MasterPasswordKeychain())
    }
}
