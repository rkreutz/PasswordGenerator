import ComposableArchitecture
import Foundation

extension PasswordGenerator {
    struct Configuration: Reducer {
        enum PasswordType {
            case domainBased
            case serviceBased
        }

        struct State: Equatable {
            @BindingState var passwordType: PasswordType
            var domain: PasswordGenerator.Domain.State
            var service: PasswordGenerator.Service.State

            var isValid: Bool {
                switch passwordType {
                case .domainBased:
                    return domain.isValid

                case .serviceBased:
                    return service.isValid
                }
            }
        }

        enum Action: BindableAction {
            case binding(BindingAction<State>)
            case domain(PasswordGenerator.Domain.Action)
            case service(PasswordGenerator.Service.Action)
        }

        var body: some ReducerOf<Self> {
            BindingReducer()
            Scope(state: \.domain, action: /Action.domain) { PasswordGenerator.Domain() }
            Scope(state: \.service, action: /Action.service) { PasswordGenerator.Service() }
        }
    }
}
