import Foundation
import struct ComposableArchitecture.Reducer
import struct ComposableArchitecture.Effect

extension CounterView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, _ -> Effect<Action, Never> in

        switch action {

        case let .counterUpdated(count):
            state.count = count
            return .none
        }
    }
}
