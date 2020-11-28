import Foundation

extension PasswordGeneratorView.PasswordView {

    enum Action {

        case generatePassword
        case updatedFlow(PasswordGeneratorView.PasswordView.Flow)
        case copyableContentUpdated(CopyableContentView.Action)
    }
}
