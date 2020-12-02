import Foundation
import ComposableArchitecture
import Combine
import PasswordGeneratorKit
import CasePaths

extension PasswordGeneratorView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    private struct GeneratePasswordHash: Hashable {}

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
        Reducer(
            bindingAction: /Action.updateError,
            to: \.error
        ),
        Reducer(forAction: /Action.logout) { _, environment -> Effect<Action, Never> in

            do {

                try environment.masterPasswordStorage.deleteMasterPassword()
                return Effect(value: Action.didLogout)
            } catch {

                return Effect(value: Action.updateError(error))
            }
        },
        Reducer(forAction: .didUpdateCharactersState) { state, _ -> Effect<Action, Never> in

            let charactersCount = state.charactersState.digitsState.counterState.count
                + state.charactersState.lowercaseState.counterState.count
                + state.charactersState.symbolsState.counterState.count
                + state.charactersState.uppercaseState.counterState.count
            let minimalLength = max(4, charactersCount)
            state.lengthState.lengthState.bounds = minimalLength ... 32
            if state.lengthState.lengthState.count < minimalLength {

                state.lengthState.lengthState.count = minimalLength
            }
            return .none
        },
        Reducer(forAction: .generatePassword) { state, environment in

            Effect(value: Action.updatedPasswordState(.updateFlow(.loading)))
                .append(
                    passwordPublisher(for: state, environment: environment)
                        .receive(on: environment.scheduler)
                        .map { Action.updatedPasswordState(.updateFlow(.generated($0))) }
                        .catch { error in

                            Effect(value: Action.updateError(error))
                                .append(Action.updatedPasswordState(.updateFlow(.readyToGenerate)))
                        }
                )
                .eraseToEffect()
                .cancellable(id: AnyHashable(GeneratePasswordHash()))
        },
        Reducer(
            forActions: .didUpdateConfigurationState,
            .didUpdateLengthState,
            .didUpdateCharactersState,
            /Action.didLogout
        ) { state, _ -> Effect<Action, Never> in

            Effect.cancel(id: AnyHashable(GeneratePasswordHash()))
                .append(
                    Effect(
                        value: state.charactersState.isValid && state.configurationState.isValid ?
                            Action.updatedPasswordState(.updateFlow(.readyToGenerate)) :
                            Action.updatedPasswordState(.updateFlow(.invalid))
                    )
                )
                .eraseToEffect()
        }
    )
}

private extension PasswordGeneratorView {

    static func passwordPublisher(for state: State, environment: Environment) -> AnyPublisher<String, PasswordGenerator.Error> {

        let publisher: AnyPublisher<String, PasswordGenerator.Error>
        switch state.configurationState.passwordType {

        case .domainBased:
            publisher = environment.passwordGenerator.publishers.generatePassword(
                username: state.configurationState.domainState.username,
                domain: state.configurationState.domainState.domain,
                seed: state.configurationState.domainState.seed.count,
                rules: rules(for: state.charactersState, length: state.lengthState.lengthState.count)
            )

        case .serviceBased:
            publisher = environment.passwordGenerator.publishers.generatePassword(
                service: state.configurationState.serviceState.service,
                rules: rules(for: state.charactersState, length: state.lengthState.lengthState.count)
            )
        }

        return publisher
    }

    static func rules(for charactersState: PasswordGeneratorView.CharactersView.State, length: Int) -> Set<PasswordRule> {

        var rules: Set<PasswordRule> = [.length(length)]

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
}

private extension CasePath where Root == PasswordGeneratorView.Action, Value == Void {

    static let generatePassword =
        /PasswordGeneratorView.Action.updatedPasswordState
        .. /PasswordGeneratorView.PasswordView.Action.generatePassword

    static let didUpdateConfigurationState =
        /PasswordGeneratorView.Action.updatedConfigurationState
        .. /PasswordGeneratorView.ConfigurationView.Action.didUpdate

    static let didUpdateLengthState =
        /PasswordGeneratorView.Action.updatedLengthState
        .. /PasswordGeneratorView.LengthView.Action.didUpdate

    static let didUpdateCharactersState =
        /PasswordGeneratorView.Action.updatedCharactersState
        .. /PasswordGeneratorView.CharactersView.Action.didUpdate
}
