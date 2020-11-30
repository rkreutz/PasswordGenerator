import Foundation
import ComposableArchitecture

extension PasswordGeneratorView.PasswordView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CopyableContentView.sharedReducer
            .pullback(
                state: \.copyableState,
                action: /Action.updateCopyableContentView,
                environment: CopyableContentView.Environment.init
            ),
        Reducer(forAction: /Action.updateFlow) { state, flow, _ -> Effect<Action, Never> in

            switch flow {

            case let .generated(password):
                state.copyableState.content = password

            default:
                state.copyableState.content = ""
            }

            state.flow = flow
            return .none
        }
    )
}
