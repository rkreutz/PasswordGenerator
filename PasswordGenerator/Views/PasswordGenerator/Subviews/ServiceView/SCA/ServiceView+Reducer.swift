import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.ServiceView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, _ -> Effect<Action, Never> in

        switch action {

        case let .updateService(service):
            state.service = service
            state.isValid = service.isNotEmpty
            return Just(Action.didUpdate).eraseToEffect()

        case .didUpdate:
            return .none
        }
    }
}
