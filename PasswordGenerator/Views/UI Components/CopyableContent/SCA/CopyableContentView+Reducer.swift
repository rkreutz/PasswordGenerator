import Foundation
import struct Combine.Just
import struct ComposableArchitecture.Reducer
import struct ComposableArchitecture.Effect

extension CopyableContentView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer { state, action, environment -> Effect<Action, Never> in

        switch action {

        case .copyContent:
            environment.pasteboard.copy(string: state.content)
            environment.hapticManager.generateHapticFeedback(.success)

            struct CopyContentHash: Hashable {}
            return Just(Action.updateCopyState(true))
                .append(
                    Just(Action.updateCopyState(false))
                        .eraseToEffect()
                        .debounce(id: CopyContentHash(), for: 1.5, scheduler: environment.scheduler)
                        .eraseToAnyPublisher()
                )
                .eraseToEffect()

        case let .updateCopyState(hasCopied):
            state.hasCopied = hasCopied
            return .none
        }
    }
}
