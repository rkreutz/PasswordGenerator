import Foundation

extension CounterToggleView {

    enum Action {

        case updateToggle(Bool)
        case didUpdate
        case counterChanged(CounterView.Action)
    }
}
