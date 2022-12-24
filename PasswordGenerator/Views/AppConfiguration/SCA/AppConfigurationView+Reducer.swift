import Foundation
import Combine
import ComposableArchitecture

extension AppConfigurationView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        Reducer(
            bindingAction: /Action.updateError,
            to: \.error
        ),
        Reducer(forAction: /Action.resetMasterPasswordTapped) { _, environment -> Effect<Action, Never> in

            do {

                try environment.masterPasswordStorage.deleteMasterPassword()
                return Effect(value: Action.didResetMasterPassword)
            } catch {

                return Effect(value: Action.updateError(error))
            }
        },
        Reducer(forAction: /Action.entropySizeUpdated) { state, size, environment in

            state.entropySize = size
            environment.entropyConfigurationStorage.save(entropySize: size)
            return Effect(value: .entropyConfigurationUpdated(generator: state.entropyGenerator, entropySize: size))
        },
        Reducer(forAction: /Action.entropyGeneratorUpdated) { state, generator, environment in

            state.entropyGenerator = generator
            environment.entropyConfigurationStorage.save(entropyGenerator: generator)
            return Effect(value: .entropyConfigurationUpdated(generator: generator, entropySize: state.entropySize))
        },
        Reducer(forAction: /Action.entropyGeneratorIterationsUpdated) { state, iterations, environment in

            switch state.entropyGenerator {

            case .pbkdf2:
                state.entropyGenerator = .pbkdf2(iterations: iterations > 0 ? iterations : Defaults.PBKDF2.iterations)

            case .argon2(_, let memory, let threads):
                state.entropyGenerator = .argon2(iterations: iterations > 0 ? iterations : Defaults.Argon2.iterations, memory: memory, threads: threads)
            }
            
            environment.entropyConfigurationStorage.save(entropyGenerator: state.entropyGenerator)
            return Effect(value: .entropyConfigurationUpdated(generator: state.entropyGenerator, entropySize: state.entropySize))
        },
        Reducer(forAction: /Action.entropyGeneratorMemoryUpdated) { state, memory, environment in

            switch state.entropyGenerator {

            case .pbkdf2:
                break

            case .argon2(let iterations, _, let threads):
                state.entropyGenerator = .argon2(iterations: iterations, memory: memory > 0 ? memory : Defaults.Argon2.memory, threads: threads)
            }

            environment.entropyConfigurationStorage.save(entropyGenerator: state.entropyGenerator)
            return Effect(value: .entropyConfigurationUpdated(generator: state.entropyGenerator, entropySize: state.entropySize))
        },
        Reducer(forAction: /Action.entropyGeneratorThreadsUpdated) { state, threads, environment in

            switch state.entropyGenerator {

            case .pbkdf2:
                break

            case .argon2(let iterations, let memory, _):
                state.entropyGenerator = .argon2(iterations: iterations, memory: memory, threads: threads > 0 ? threads : Defaults.Argon2.threads)
            }

            environment.entropyConfigurationStorage.save(entropyGenerator: state.entropyGenerator)
            return Effect(value: .entropyConfigurationUpdated(generator: state.entropyGenerator, entropySize: state.entropySize))
        }
    )
}
