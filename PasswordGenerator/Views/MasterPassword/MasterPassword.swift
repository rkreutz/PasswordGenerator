import ComposableArchitecture
import Foundation

struct MasterPassword: Reducer {
    struct State: Equatable {
        @BindingState var masterPassword: String = ""
        var isValid: Bool = false
        var error: Error?

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.masterPassword == rhs.masterPassword
            && lhs.isValid == rhs.isValid
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didTapSave
        case didSaveMasterPassword
        case didReceiveError(Error?)
    }

    @Dependency(\.masterPasswordStorage) var masterPasswordStorage

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$masterPassword):
                state.isValid = state.masterPassword.isNotEmpty
                return .none

            case .didTapSave:
                return .task { [masterPassword = state.masterPassword] in
                    do {
                        try masterPasswordStorage.save(masterPassword: masterPassword)
                        return .didSaveMasterPassword
                    } catch {
                        return .didReceiveError(error)
                    }
                }

            case .didReceiveError(let error):
                state.error = error
                return .none

            default:
                return .none
            }
        }
    }
}
