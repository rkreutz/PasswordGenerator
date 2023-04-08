import ComposableArchitecture
import Foundation

extension PasswordGenerator {
    struct Password: Reducer {
        enum Flow: Equatable {
            case invalid
            case readyToGenerate
            case loading
            case generated(String)
        }

        struct State: Equatable {
            var flow: Flow
            var copyableContent: CopyableContent.State
        }

        enum Action {
            case didTapButton
            case updateFlow(Flow)
            case copyableContent(CopyableContent.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.copyableContent, action: /Action.copyableContent) { CopyableContent() }
            Reduce { state, action in
                switch action {
                case .updateFlow(.generated(let password)):
                    state.copyableContent.content = password
                    state.flow = .generated(password)
                    return .none

                case .updateFlow(let flow):
                    state.copyableContent.content = ""
                    state.flow = flow
                    return .none

                default:
                    return .none
                }
            }
        }
    }
}
