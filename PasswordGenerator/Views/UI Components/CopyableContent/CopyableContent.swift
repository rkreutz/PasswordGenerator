import ComposableArchitecture
import Foundation

struct CopyableContent: Reducer {
    struct State: Equatable {
        var content: String
        var hasCopied: Bool = false
    }

    enum Action: Equatable {
        case didTapCopyButton
        case didFinishAnimation
    }

    @Dependency(\.pasteboard) var pasteboard
    @Dependency(\.hapticManager) var hapticManager
    @Dependency(\.sleep) var sleep

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapCopyButton:
                pasteboard.copy(string: state.content)
                hapticManager.generateHapticFeedback(.success)
                state.hasCopied = true
                struct CopyContentHash: Hashable {}
                return .run { send in
                    do {
                        try await send(
                            withTaskCancellation(
                                id: CopyContentHash(),
                                cancelInFlight: true,
                                operation: {
                                    try await sleep(.milliseconds(1_500))
                                    return .didFinishAnimation
                                }
                            )
                        )
                    } catch {
                        guard !(error is CancellationError) else { return }
                        await send(Action.didFinishAnimation)
                    }
                }
            case .didFinishAnimation:
                state.hasCopied = false
                return .none
            }
        }
    }
}
