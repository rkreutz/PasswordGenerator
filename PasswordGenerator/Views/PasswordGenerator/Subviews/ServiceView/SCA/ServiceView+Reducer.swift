import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.ServiceView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, _ -> Effect<Action, Never> in

        switch action {

        case let .updatedService(service):
            state.service = service
            let isValid = service.isNotEmpty
            if state.isValid != isValid {

                return Just(Action.updatedValidity(isValid)).eraseToEffect()
            } else {

                return .none
            }

        case let .updatedValidity(isValid):
            state.isValid = isValid
            return .none
        }
    }
}
