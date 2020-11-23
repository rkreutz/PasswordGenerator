import SwiftUI

final class StateReference<State>: ObservableObject {

    @Published var state: State

    init(state: State) {

        self.state = state
    }
}
