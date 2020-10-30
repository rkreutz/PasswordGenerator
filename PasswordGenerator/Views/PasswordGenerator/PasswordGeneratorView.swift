import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers

struct PasswordGeneratorView: View {

    @State var viewState = ViewState()

    @Environment(\.appState) private var appState
    @Environment(\.masterPasswordStorage) private var masterPasswordStorage
    @Environment(\.passwordGenerator) private var passwordGenerator

    @ScaledMetric private var spacing: CGFloat = 16

    private var cancellableStore = CancellableStore()

    private var generatePasswordPublisher: AnyPublisher<String, PasswordGenerator.Error> {

        switch viewState.configurationState.passwordType {

        case .domainBased:
            return passwordGenerator.publishers.generatePassword(
                username: viewState.configurationState.username,
                domain: viewState.configurationState.domain,
                seed: viewState.configurationState.seed,
                rules: viewState.rules
            )
        case .serviceBased:
            return passwordGenerator.publishers.generatePassword(
                service: viewState.configurationState.service,
                rules: viewState.rules
            )
        }
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: spacing) {

                ConfigurationView(configurationState: $viewState.configurationState)

                LengthView(charactersState: $viewState.charactersState)

                CharactersView(charactersState: $viewState.charactersState)

                PasswordView(passwordState: viewState.passwordState, action: generatePassword)
            }
            .padding(spacing)
        }
        .emittingError($viewState.error)
        .navigationBarItems(
            trailing: Button(
                action: logout,
                label: {

                    Text(Strings.PasswordGeneratorView.resetMasterPassword)
                        .font(.headline)
                }
            )
        )
        .onChange(of: viewState) { [oldState = viewState] newState in

            guard
                oldState.charactersState != newState.charactersState || oldState.configurationState != newState.configurationState
                else { return }

            cancellableStore.dispose()
            viewState.passwordState = newState.isValid ? .readyToGenerate : .invalid
        }
        .navigationBarTitle("", displayMode: .inline)
    }

    private func generatePassword() {

        generatePasswordPublisher
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveRequest: { _ in viewState.passwordState = .loading })
            .sink(
                receiveCompletion: { completion in

                    guard case let .failure(error) = completion else { return }
                    viewState.error = error
                    viewState.passwordState = .readyToGenerate
                },
                receiveValue: { viewState.passwordState = .generated($0) }
            )
            .store(in: cancellableStore)
    }

    private func logout() {

        do {

            try masterPasswordStorage.deleteMasterPassword()
            appState.state = .mustProvideMasterPassword
        } catch {

            viewState.error = error
        }
    }
}

extension PasswordGeneratorView {

    init(viewState: PasswordGeneratorView.ViewState) {

        self.viewState = viewState
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
