import Foundation

extension CounterToggleView {

    enum Action {

        case toggleChanged(Bool)
        case counterChanged(CounterView.Action)
    }
}
