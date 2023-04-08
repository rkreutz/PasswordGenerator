import ComposableArchitecture
import Foundation

struct Counter: Reducer {
    struct State: Equatable {
        @BindingState var count: Int
        var bounds: ClosedRange<Int>
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
    }
}
