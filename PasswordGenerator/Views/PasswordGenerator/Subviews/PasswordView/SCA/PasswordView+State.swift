import Foundation

extension PasswordGeneratorView.PasswordView {

    struct State: Equatable {

        var flow: Flow
        var copyableState: CopyableContentView.State
    }

    enum Flow: Equatable {

        case invalid
        case readyToGenerate
        case loading
        case generated(String)
    }
}
