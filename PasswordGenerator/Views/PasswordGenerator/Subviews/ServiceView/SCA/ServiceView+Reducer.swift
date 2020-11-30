import Foundation
import ComposableArchitecture

extension PasswordGeneratorView.ServiceView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer(forAction: /Action.updateService) { state, service, _ -> Effect<Action, Never> in

        state.service = service
        state.isValid = service.isNotEmpty
        return Effect(value: Action.didUpdate)
    }
}
