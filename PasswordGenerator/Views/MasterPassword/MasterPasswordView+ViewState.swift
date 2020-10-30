import Foundation

extension MasterPasswordView {

    struct ViewState {

        var masterPassword: String = ""
        var error: Error?

        var isValid: Bool { masterPassword.isNotEmpty }
    }
}
