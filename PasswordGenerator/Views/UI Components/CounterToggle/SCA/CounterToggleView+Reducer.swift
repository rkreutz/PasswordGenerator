import Foundation
import ComposableArchitecture
import CasePaths

extension CounterToggleView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.counterState,
                action: /Action.counterChanged,
                environment: { _ in CounterView.Environment() }
            ),
        Reducer(
            bindingAction: /Action.updateToggle,
            to: \.isToggled,
            producing: { _ in Effect(value: Action.didUpdate) }
        ),
        Reducer(
            forAction: didUpdateCounter,
            handler: { _, _ in Effect(value: Action.didUpdate) }
        )
    )

    private static let didUpdateCounter = /Action.counterChanged .. /CounterView.Action.didUpdate
}
