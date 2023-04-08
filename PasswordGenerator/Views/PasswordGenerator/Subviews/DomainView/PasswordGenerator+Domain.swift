import ComposableArchitecture
import Foundation

extension PasswordGenerator {
    struct Domain: Reducer {
        struct State: Equatable {
            @BindingState var username: String
            @BindingState var domain: String
            var seed: Counter.State

            var isValid: Bool {
                let isValidDomain = domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)
                let isValidUsername = username.isNotEmpty
                return isValidDomain && isValidUsername
            }
        }

        enum Action: BindableAction {
            case binding(BindingAction<State>)
            case seed(Counter.Action)
        }

        var body: some ReducerOf<Self> {
            BindingReducer()
            Scope(state: \.seed, action: /Action.seed) { Counter() }
        }
    }
}
