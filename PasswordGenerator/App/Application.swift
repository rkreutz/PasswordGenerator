import Combine
import ComposableArchitecture
#if os(iOS)
import UIKit
#else
import Foundation
#endif

struct Application: Reducer {
    struct State: Equatable {
        enum Tab: Hashable {
            case generator
            case config
        }

        var isMasterPasswordSet: Bool
        @BindingState var tab: Tab
        var masterPassword: MasterPassword.State
        var passwordGenerator: PasswordGenerator.State
        var configuration: AppConfiguration.State
    }

    enum Action: BindableAction {
        #if os(iOS)
        case none
        #endif
        case didInitialiseApp
        case binding(BindingAction<State>)
        case masterPassword(MasterPassword.Action)
        case passwordGenerator(PasswordGenerator.Action)
        case configuration(AppConfiguration.Action)
    }

    @Dependency(\.entropyConfigurationStorage) var entropyConfigurationStorage

    let scheduler: AnySchedulerOf<DispatchQueue>

    init<S: Scheduler>(
        scheduler: S = DispatchQueue.main
    ) where S.SchedulerTimeType == DispatchQueue.SchedulerTimeType, S.SchedulerOptions == DispatchQueue.SchedulerOptions {
        self.scheduler = AnyScheduler(scheduler)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.masterPassword, action: /Action.masterPassword) { MasterPassword() }
        Scope(state: \.passwordGenerator, action: /Action.passwordGenerator) { PasswordGenerator() }
        Scope(state: \.configuration, action: /Action.configuration) { AppConfiguration() }
        Reduce { state, action in
            switch action {
            case .didInitialiseApp:
                return Effect.publisher {
                    entropyConfigurationStorage.configurationChanges()
                        .receive(on: scheduler)
                        .flatMap { change in
                            switch change {
                            case .entropySize(let entropySize):
                                return Just(Action.configuration(.set(\.$entropySize, entropySize))).eraseToAnyPublisher()
                            case let .entropyGenerator(.pbkdf2(iterations)):
                                return [
                                    Action.configuration(.set(\.$derivationAlgorithm, .pbkdf)),
                                    Action.configuration(.set(\.$iterations, iterations))
                                ].publisher.eraseToAnyPublisher()
                            case let .entropyGenerator(.argon2(iterations, memory, threads)):
                                return [
                                    Action.configuration(.set(\.$derivationAlgorithm, .argon)),
                                    Action.configuration(.set(\.$iterations, iterations)),
                                    Action.configuration(.set(\.$memory, memory)),
                                    Action.configuration(.set(\.$threads, threads))
                                ].publisher.eraseToAnyPublisher()
                            case let .entropyGeneratorIterations(iterations):
                                return Just(Action.configuration(.set(\.$iterations, iterations))).eraseToAnyPublisher()
                            case let .entropyGeneratorMemory(memory):
                                return Just(Action.configuration(.set(\.$memory, memory))).eraseToAnyPublisher()
                            case let .entropyGeneratorThreads(threads):
                                return Just(Action.configuration(.set(\.$threads, threads))).eraseToAnyPublisher()
                            }
                        }
                }

            case .masterPassword(.didSaveMasterPassword):
                state.isMasterPasswordSet = true
                state.masterPassword.masterPassword = ""
                return .none

            case .configuration(.didResetMasterPassword):
                state.isMasterPasswordSet = false
                return .send(Action.passwordGenerator(.didResetMasterPassword))

            case .configuration(.binding(\.$entropySize)):
                state.passwordGenerator.entropySize = state.configuration.entropySize
                return .none

            case .configuration(.binding):
                state.passwordGenerator.entropyGenerator = state.configuration.entropyGenerator
                return .none

            #if APP
            case .configuration(.didScrollView):
                #if os(iOS)
                UIApplication.shared.windows.forEach { $0.endEditing(true) }
                #endif
                return .none
            #endif

            default:
                return .none
            }
        }
    }
}
