import ComposableArchitecture
import Foundation

struct MasterPassword: Reducer {
    struct State: Equatable {
        @BindingState var masterPassword: String = ""
        var error: Error?

        var isValid: Bool { masterPassword.isNotEmpty }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.masterPassword == rhs.masterPassword
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
