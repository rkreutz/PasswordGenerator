import Foundation
import ComposableArchitecture
import CasePaths

extension PasswordGeneratorView.LengthView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.lengthState,
                action: /Action.updatedLengthCounter,
                environment: { _ in CounterView.Environment() }
            ),
        Reducer(
            forAction: .didUpdateLengthCounter,
            handler: { _, _ in Effect(value: Action.didUpdate) }
        )
    )
}

private extension CasePath where Root == PasswordGeneratorView.LengthView.Action, Value == Void {

    static let didUpdateLengthCounter = /PasswordGeneratorView.LengthView.Action.updatedLengthCounter .. /CounterView.Action.didUpdate
}
