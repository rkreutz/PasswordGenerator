import ComposableArchitecture
import Foundation

extension PasswordGenerator {
    struct Service: Reducer {
        struct State: Equatable {
            @BindingState var service: String

            var isValid: Bool { service.isNotEmpty }
        }

        enum Action: BindableAction {
            case binding(BindingAction<State>)
        }

        var body: some ReducerOf<Self> {
            BindingReducer()
        }
    }
}
