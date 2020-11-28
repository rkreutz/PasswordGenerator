import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.PasswordView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CopyableContentView.sharedReducer
            .pullback(
                state: \.copyableState,
                action: /Action.copyableContentUpdated,
                environment: CopyableContentView.Environment.init
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case let .updatedFlow(.generated(password)):
                state.flow = .generated(password)
                return Just(Action.copyableContentUpdated(.updateContent(password))).eraseToEffect()

            case let .updatedFlow(flow):
                state.flow = flow
                return .none

            default:
                return .none
            }
        }
    )
}
