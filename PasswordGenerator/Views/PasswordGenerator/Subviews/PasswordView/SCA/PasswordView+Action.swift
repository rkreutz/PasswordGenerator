import Foundation

extension PasswordGeneratorView.PasswordView {

    enum Action {

        case generatePassword
        case updateFlow(Flow)
        case updateCopyableContentView(CopyableContentView.Action)
    }
}
