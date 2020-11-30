import Foundation
import ComposableArchitecture

extension CopyableContentView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        Reducer(
            bindingAction: /Action.updateCopyState,
            to: \.hasCopied
        ),
        Reducer(forAction: /Action.copyContent) { state, environment -> Effect<Action, Never> in

            environment.pasteboard.copy(string: state.content)
            environment.hapticManager.generateHapticFeedback(.success)

            struct CopyContentHash: Hashable {}
            return Effect(value: Action.updateCopyState(true))
                .append(
                    Effect(value: Action.updateCopyState(false))
                        .eraseToEffect()
                        .debounce(id: CopyContentHash(), for: 1.5, scheduler: environment.scheduler)
                        .eraseToAnyPublisher()
                )
                .eraseToEffect()
        }
    )
}
