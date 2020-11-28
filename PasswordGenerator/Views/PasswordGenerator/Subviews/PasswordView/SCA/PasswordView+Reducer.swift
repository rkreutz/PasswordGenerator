import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.PasswordView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CopyableContentView.sharedReducer
            .pullback(
                state: \.copyableState,
                action: /Action.updateCopyableContentView,
                environment: CopyableContentView.Environment.init
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case let .updateFlow(.generated(password)):
                state.copyableState.content = password
                state.flow = .generated(password)
                return .none

            case let .updateFlow(flow):
                state.copyableState.content = ""
                state.flow = flow
                return .none

            default:
                return .none
            }
        }
    )
}
