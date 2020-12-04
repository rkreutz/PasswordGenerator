import Foundation

extension CounterToggleView {

    struct State: Equatable {

        let toggleTitle: String
        var isToggled: Bool
        var counterState: CounterView.State
    }
}
