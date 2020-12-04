import Foundation
import Combine
import ComposableArchitecture

extension MasterPasswordView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        Reducer(
            bindingAction: /Action.updateError,
            to: \.error
        ),
        Reducer(forAction: /Action.textFieldChanged) { state, text, _ -> Effect<Action, Never> in

            state.masterPassword = text
            state.isValid = text.isNotEmpty
            return .none
        },
        Reducer(forAction: /Action.saveMasterPassword) { state, environment -> Effect<Action, Never> in

            do {

                try environment.masterPasswordStorage.save(masterPassword: state.masterPassword)
                return Effect(value: Action.masterPasswordSaved)
            } catch {

                return Effect(value: Action.updateError(error))
            }
        }
    )
}
