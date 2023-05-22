import Combine
import ComposableArchitecture
import Foundation
import PasswordGeneratorKit

struct PasswordGenerator: Reducer {

    private struct GeneratePasswordHash: Hashable {}

    struct State: Equatable {
        var configuration: Configuration.State
        var length: Length.State
        var characters: Characters.State
        var password: Password.State
        var entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator
        var entropySize: UInt
        var error: Error?

        #if APP
        var shouldShowPasswordStrength: Bool
        var passwordEntropy: PasswordEntropy.State {
            let characterSetBits = log2(Double(characters.charactersPoolSize))
            let passwordEntropyBits = Double(length.count) * characterSetBits
            return .init(
                passwordEntropy: passwordEntropyBits,
                entropyGeneratorSize: entropySize
            )
        }
        #endif

        var canGeneratePassword: Bool {
            configuration.isValid && characters.isValid
        }

        static func == (lhs: Self, rhs: Self) -> Bool {

            lhs.configuration == rhs.configuration
            && lhs.length == rhs.length
            && lhs.characters == rhs.characters
            && lhs.password == rhs.password
            && lhs.entropyGenerator == rhs.entropyGenerator
            && lhs.entropySize == rhs.entropySize
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }

    enum Action {
        case didResetMasterPassword
        case configuration(Configuration.Action)
        case length(Length.Action)
        case characters(Characters.Action)
        case password(Password.Action)
        case didReceiveError(Error?)
    }

    @Dependency(\.masterPasswordProvider) var masterPasswordProvider

    let scheduler: AnySchedulerOf<DispatchQueue>

    init<S: Scheduler>(
        scheduler: S = DispatchQueue.main
    ) where S.SchedulerTimeType == DispatchQueue.SchedulerTimeType, S.SchedulerOptions == DispatchQueue.SchedulerOptions {
        self.scheduler = AnyScheduler(scheduler)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.configuration, action: /Action.configuration) { Configuration() }
        Scope(state: \.length, action: /Action.length) { Length() }
        Scope(state: \.characters, action: /Action.characters) { Characters() }
        Scope(state: \.password, action: /Action.password) { Password() }
        Reduce { state, action in
            switch action {
            case .didReceiveError(let error):
                state.error = error
                return .none

            case .characters:
                let minLength = max(state.characters.totalCharacters, 4)
                if state.length.count < minLength {
                    state.length.count = minLength
                }
                state.length.bounds = minLength ... 32
                return cancelPasswordGeneration(state: &state)
                
            case .configuration,
                 .length,
                 .didResetMasterPassword:
                return cancelPasswordGeneration(state: &state)

            case .password(.didTapGenerate):
                state.password.flow = .loading
                return Effect.publisher { [state] in
                    passwordPublisher(for: state)
                        .receive(on: scheduler)
                        .map { Action.password(.updateFlow(.generated($0))) }
                        .catch {
                            Publishers.Merge(
                                Just(Action.didReceiveError($0)),
                                Just(Action.password(.updateFlow(.readyToGenerate)))
                            )
                        }
                }.cancellable(id: AnyHashable(GeneratePasswordHash()), cancelInFlight: true)

            default:
                return .none
            }
        }
    }

    func cancelPasswordGeneration(state: inout State) -> Effect<Action> {
        state.password.flow = state.canGeneratePassword ? .readyToGenerate : .invalid
        return .cancel(id: AnyHashable(GeneratePasswordHash()))
    }

    func passwordPublisher(for state: State) -> AnyPublisher<String, PasswordGeneratorKit.PasswordGenerator.Error> {
        let passwordGenerator = PasswordGeneratorKit.PasswordGenerator(
            masterPasswordProvider: masterPasswordProvider,
            entropyGenerator: state.entropyGenerator,
            bytes: state.entropySize
        )
        let publisher: AnyPublisher<String, PasswordGeneratorKit.PasswordGenerator.Error>
        switch state.configuration.passwordType {

        case .domainBased:
            publisher = passwordGenerator.publishers.generatePassword(
                username: state.configuration.domain.username,
                domain: state.configuration.domain.domain,
                seed: state.configuration.domain.seed.count,
                rules: rules(for: state.characters, length: state.length)
            )
    
        case .serviceBased:
            publisher = passwordGenerator.publishers.generatePassword(
                service: state.configuration.service.service,
                rules: rules(for: state.characters, length: state.length)
            )
        }

        return publisher
    }

    func rules(for characters: PasswordGenerator.Characters.State, length: PasswordGenerator.Length.State) -> Set<PasswordRule> {
        var rules: Set<PasswordRule> = [.length(UInt(length.count))]
        if characters.digits.isToggled {
            rules.insert(.mustContainDecimalCharacters(atLeast: UInt(characters.digits.counter.count)))
        }
        if characters.lowercase.isToggled {
            rules.insert(.mustContainLowercaseCharacters(atLeast: UInt(characters.lowercase.counter.count)))
        }
        if characters.symbols.isToggled {
            rules.insert(.mustContainSymbolCharacters(atLeast: UInt(characters.symbols.counter.count)))
        }
        if characters.uppercase.isToggled {
            rules.insert(.mustContainUppercaseCharacters(atLeast: UInt(characters.uppercase.counter.count)))
        }
        return rules
    }
}
