import Foundation
import ComposableArchitecture
import Combine
import PasswordGeneratorKit

extension PasswordGeneratorView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        ConfigurationView.sharedReducer
            .pullback(
                state: \.configurationState,
                action: /Action.updatedConfigurationState,
                environment: { _ in .init() }
            ),
        LengthView.sharedReducer
            .pullback(
                state: \.lengthState,
                action: /Action.updatedLengthState,
                environment: { _ in .init() }
            ),
        CharactersView.sharedReducer
            .pullback(
                state: \.charactersState,
                action: /Action.updatedCharactersState,
                environment: { _ in .init() }
            ),
        PasswordView.sharedReducer
            .pullback(
                state: \.passwordState,
                action: /Action.updatedPasswordState,
                environment: PasswordView.Environment.init
            ),
        Reducer { state, action, environment -> Effect<Action, Never> in

            struct GeneratePasswordHash: Hashable {}

            func characterRules(for charactersState: PasswordGeneratorView.CharactersView.State) -> Set<PasswordRule> {

                var rules = Set<PasswordRule>()
                if charactersState.digitsState.isToggled {

                    rules.insert(.mustContainDecimalCharacters(atLeast: charactersState.digitsState.counterState.count))
                }
                if charactersState.lowercaseState.isToggled {

                    rules.insert(.mustContainLowercaseCharacters(atLeast: charactersState.lowercaseState.counterState.count))
                }
                if charactersState.symbolsState.isToggled {

                    rules.insert(.mustContainSymbolCharacters(atLeast: charactersState.symbolsState.counterState.count))
                }
                if charactersState.uppercaseState.isToggled {

                    rules.insert(.mustContainUppercaseCharacters(atLeast: charactersState.uppercaseState.counterState.count))
                }
                return rules
            }

            switch action {

            case .logout:
                do {

                    try environment.masterPasswordStorage.deleteMasterPassword()
                    return Effect.cancel(id: AnyHashable(GeneratePasswordHash()))
                        .append(Just(Action.didLogout))
                        .eraseToEffect()
                } catch {

                    return Just(Action.updateError(error)).eraseToEffect()
                }

            case let .updateError(error):
                state.error = error
                return .none

            case .updatedPasswordState(.generatePassword):
                let publisher: AnyPublisher<String, PasswordGenerator.Error>
                switch state.configurationState.passwordType {

                case .domainBased:
                    publisher = environment.passwordGenerator.publishers.generatePassword(
                        username: state.configurationState.domainState.username,
                        domain: state.configurationState.domainState.domain,
                        seed: state.configurationState.domainState.seed.count,
                        rules: characterRules(for: state.charactersState)
                            .union([PasswordRule.length(state.lengthState.lengthState.count)])
                    )

                case .serviceBased:
                    publisher = environment.passwordGenerator.publishers.generatePassword(
                        service: state.configurationState.serviceState.service,
                        rules: characterRules(for: state.charactersState)
                            .union([PasswordRule.length(state.lengthState.lengthState.count)])
                    )
                }

                return Just(Action.updatedPasswordState(.updateFlow(.loading)))
                    .append(
                        publisher
                            .receive(on: environment.scheduler)
                            .map { Action.updatedPasswordState(.updateFlow(.generated($0))) }
                            .catch { error in

                                Just(Action.updateError(error))
                                    .append(Action.updatedPasswordState(.updateFlow(.readyToGenerate)))
                            }
                    )
                    .eraseToEffect()
                    .cancellable(id: AnyHashable(GeneratePasswordHash()))

            case .updatedCharactersState(.didUpdate):
                let charactersCount = state.charactersState.digitsState.counterState.count
                    + state.charactersState.lowercaseState.counterState.count
                    + state.charactersState.symbolsState.counterState.count
                    + state.charactersState.uppercaseState.counterState.count
                let minimalLength = max(4, charactersCount)
                state.lengthState.lengthState.bounds = minimalLength ... 32
                if state.lengthState.lengthState.count < minimalLength {

                    state.lengthState.lengthState.count = minimalLength
                }
                return Effect.cancel(id: AnyHashable(GeneratePasswordHash()))
                    .append(
                        Just(
                            state.charactersState.isValid && state.configurationState.isValid ?
                                Action.updatedPasswordState(.updateFlow(.readyToGenerate)) :
                                Action.updatedPasswordState(.updateFlow(.invalid))
                        )
                    )
                    .eraseToEffect()

            case .updatedConfigurationState(.didUpdate),
                 .updatedLengthState(.didUpdate):
                return Effect.cancel(id: AnyHashable(GeneratePasswordHash()))
                .append(
                    Just(
                        state.charactersState.isValid && state.configurationState.isValid ?
                            Action.updatedPasswordState(.updateFlow(.readyToGenerate)) :
                            Action.updatedPasswordState(.updateFlow(.invalid))
                    )
                )
                .eraseToEffect()

            default:
                return .none
            }
        }
    )
}
