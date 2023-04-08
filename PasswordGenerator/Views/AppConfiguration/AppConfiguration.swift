import ComposableArchitecture
import PasswordGeneratorKit
import Foundation

struct AppConfiguration: Reducer {

    enum KeyDerivationAlgorithm {
        case pbkdf
        case argon
    }

    struct State: Equatable {
        @BindingState var derivationAlgorithm: KeyDerivationAlgorithm
        @BindingState var iterations: UInt
        @BindingState var memory: UInt
        @BindingState var threads: UInt
        @BindingState var entropySize: UInt
        var error: Error?

        var entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator {
            switch derivationAlgorithm {
            case .argon:
                return .argon2(iterations: iterations, memory: memory, threads: threads)
            case .pbkdf:
                return .pbkdf2(iterations: iterations)
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.derivationAlgorithm == rhs.derivationAlgorithm
            && lhs.iterations == rhs.iterations
            && lhs.memory == rhs.memory
            && lhs.threads == rhs.threads
            && lhs.entropySize == rhs.entropySize
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case didTapResetMasterPassword
        case didResetMasterPassword
        case didScrollView
        case didReceiveError(Error?)
    }

    @Dependency(\.masterPasswordStorage) var masterPasswordStorage
    @Dependency(\.entropyConfigurationStorage) var entropyConfigurationStorage

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTapResetMasterPassword:
                return .task {
                    do {
                        try masterPasswordStorage.deleteMasterPassword()
                        return .didResetMasterPassword
                    } catch {
                        return .didReceiveError(error)
                    }
                }

            case .didReceiveError(let error):
                state.error = error
                return .none

            case .binding(\.$entropySize):
                entropyConfigurationStorage.save(entropySize: state.entropySize)
                return .none

            case .binding(\.$derivationAlgorithm):
                switch state.derivationAlgorithm {
                case .pbkdf:
                    state.iterations = 1_000
                case .argon:
                    state.iterations = 3
                    state.memory = 16_384
                    state.threads = 1
                }
                return saveEntropyGeneratorChanges(state: state)

            case .binding(\.$iterations),
                 .binding(\.$memory),
                 .binding(\.$threads):
                return saveEntropyGeneratorChanges(state: state)
                
            default:
                return .none
            }
        }
    }

    func saveEntropyGeneratorChanges(state: State) -> Effect<Action> {
        entropyConfigurationStorage.save(entropyGenerator: state.entropyGenerator)
        return .none
    }
}
