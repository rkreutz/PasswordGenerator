import SwiftUI

final class AppState: ObservableObject {

    enum State: Equatable {

        case mustProvideMasterPassword
        case masterPasswordSet
    }

    @Published var state: State

    init(state: State) {

        self.state = state
    }

    init(from masterPasswordValidator: MasterPasswordValidator) {

        self.state = masterPasswordValidator.hasMasterPassword ? .masterPasswordSet : .mustProvideMasterPassword
    }
}
