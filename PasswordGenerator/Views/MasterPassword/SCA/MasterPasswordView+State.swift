import Foundation

extension MasterPasswordView {

    struct State: Equatable {

        var masterPassword: String = ""
        var isValid: Bool = false
        var error: Error?

        static func == (lhs: MasterPasswordView.State, rhs: MasterPasswordView.State) -> Bool {

            lhs.masterPassword == rhs.masterPassword
                && lhs.isValid == rhs.isValid
                && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }
}
