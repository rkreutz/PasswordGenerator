import Foundation

extension MasterPasswordView {

    enum Action {

        case textFieldChanged(String)
        case saveMasterPassword
        case masterPasswordSaved
        case updateError(Error?)
    }
}
