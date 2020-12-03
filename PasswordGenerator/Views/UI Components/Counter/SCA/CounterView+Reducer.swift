import Foundation
import ComposableArchitecture

extension CounterView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer(
        bindingAction: /Action.update,
        to: \.count,
        handler: { _, _, _ in Effect(value: Action.didUpdate) }
    )
}
