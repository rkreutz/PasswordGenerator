import ComposableArchitecture
import Foundation

struct CounterToggle: Reducer {
    struct State: Equatable {
        @BindingState var isToggled: Bool
        var counter: Counter.State
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case counter(Counter.Action)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.counter, action: /Action.counter) { Counter() }
        Reduce { state, action in
            switch action {
            case .binding:
                state.counter.count = state.isToggled ? 1 : 0
                return .none
            default:
                return .none
            }
        }
    }
}
