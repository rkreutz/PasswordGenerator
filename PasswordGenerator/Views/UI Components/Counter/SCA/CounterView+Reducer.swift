import Foundation
import Combine
import struct ComposableArchitecture.Reducer
import struct ComposableArchitecture.Effect

extension CounterView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, _ -> Effect<Action, Never> in

        switch action {

        case let .update(count):
            state.count = count
            return Just(Action.didUpdate).eraseToEffect()

        case .didUpdate:
            return .none
        }
    }
}
