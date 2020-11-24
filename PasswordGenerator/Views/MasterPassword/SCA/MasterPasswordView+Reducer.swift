import Foundation
import Combine
import ComposableArchitecture

extension MasterPasswordView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, environment -> Effect<Action, Never> in

        switch action {

        case let .textFieldChanged(text):
            state.masterPassword = text
            state.isValid = text.isNotEmpty
            return .none

        case .saveMasterPassword:
            return Deferred { [masterPassword = state.masterPassword] () -> AnyPublisher<Action, Never> in

                do {

                    try environment.masterPasswordStorage.save(masterPassword: masterPassword)
                    return Just(Action.masterPasswordSaved).eraseToAnyPublisher()
                } catch {

                    return Just(Action.failed(error)).eraseToAnyPublisher()
                }
            }
            .eraseToEffect()

        case .masterPasswordSaved:
            return .none

        case let .failed(error):
            state.error = error
            return .none

        case .clearError:
            state.error = nil
            return .none
        }
    }
}
