import SwiftUI

enum MasterPasswordValidatorEnvironmentKey: EnvironmentKey {

    static var defaultValue: MasterPasswordValidator = MasterPasswordKeychain()
}

extension EnvironmentValues {

    var masterPasswordValidator: MasterPasswordValidator {

        get { self[MasterPasswordValidatorEnvironmentKey.self] }
        set { self[MasterPasswordValidatorEnvironmentKey.self] = newValue }
    }
}

extension View {

    func use(masterPasswordValidator: MasterPasswordValidator) -> some View {

        environment(\.masterPasswordValidator, masterPasswordValidator)
    }
}
