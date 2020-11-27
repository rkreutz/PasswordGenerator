import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers
import ComposableArchitecture

struct PasswordGeneratorView: View {

    @StateObject var viewState = StateReference(state: ViewState())

    @Environment(\.appState) private var appState
    @Environment(\.masterPasswordStorage) private var masterPasswordStorage
    @Environment(\.passwordGenerator) private var passwordGenerator

    @ScaledMetric private var spacing: CGFloat = 16

    private var cancellableStore = CancellableStore()

    private var generatePasswordPublisher: AnyPublisher<String, PasswordGenerator.Error> {

        switch viewState.state.configurationState.passwordType {

        case .domainBased:
            return passwordGenerator.publishers.generatePassword(
                username: viewState.state.configurationState.username,
                domain: viewState.state.configurationState.domain,
                seed: viewState.state.configurationState.seed,
                rules: viewState.state.rules
            )
        case .serviceBased:
            return passwordGenerator.publishers.generatePassword(
                service: viewState.state.configurationState.service,
                rules: viewState.state.rules
            )
        }
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: spacing) {

                ConfigurationView(configurationState: $viewState.state.configurationState)

                LengthView(charactersState: $viewState.state.charactersState)

                CharactersView(
                    store: .init(
                        initialState: .init(
                            digitsState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.decimalCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            symbolsState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters.formatted(),
                                isToggled: false,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 0,
                                    bounds: 1 ... 8
                                )
                            ),
                            lowercaseState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            uppercaseState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            isValid: true
                        ),
                        reducer: PasswordGeneratorView.CharactersView.sharedReducer,
                        environment: PasswordGeneratorView.CharactersView.Environment()
                    )
                )

                PasswordView(passwordState: viewState.state.passwordState, action: generatePassword)
            }
            .padding(spacing)
        }
        .emittingError($viewState.state.error)
        .navigationBarItems(
            trailing: Button(
                action: logout,
                label: {

                    Text(Strings.PasswordGeneratorView.resetMasterPassword)
                        .font(.headline)
                }
            )
        )
        .onChange(of: viewState.state) { [oldState = viewState.state] newState in

            guard
                oldState.charactersState != newState.charactersState || oldState.configurationState != newState.configurationState
                else { return }

            cancellableStore.dispose()
            viewState.state.passwordState = newState.isValid ? .readyToGenerate : .invalid
        }
        .navigationBarTitle("", displayMode: .inline)
    }

    private func generatePassword() {

        generatePasswordPublisher
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveRequest: { _ in viewState.state.passwordState = .loading })
            .sink(
                receiveCompletion: { completion in

                    guard case let .failure(error) = completion else { return }
                    viewState.state.error = error
                    viewState.state.passwordState = .readyToGenerate
                },
                receiveValue: { viewState.state.passwordState = .generated($0) }
            )
            .store(in: cancellableStore)
    }

    private func logout() {

        do {

            try masterPasswordStorage.deleteMasterPassword()
            appState.state = .mustProvideMasterPassword
        } catch {

            viewState.state.error = error
        }
    }
}

extension PasswordGeneratorView {

    init(viewStateReference: StateReference<ViewState>) {

        self._viewState = StateObject(wrappedValue: viewStateReference)
    }
}

#if DEBUG

struct PasswordGeneratorView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            PasswordGeneratorView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView()
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
        .use(masterPasswordStorage: MockMasterPasswordStorage())
        .use(passwordGenerator: PasswordGenerator(masterPasswordProvider: "masterPassword"))
        .environmentObject(AppState(state: .masterPasswordSet))
    }
}

#endif
