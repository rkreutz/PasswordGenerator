import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers
import ComposableArchitecture

struct PasswordGeneratorView: View {

    @ScaledMetric private var spacing: CGFloat = 16

    let store: Store<State, Action>

    var body: some View {

        WithViewStore(store) { viewStore in

            ScrollView {

                VStack(alignment: .center, spacing: spacing) {

                    ConfigurationView(store: store.scope(state: \.configurationState, action: Action.updatedConfigurationState))

                    LengthView(store: store.scope(state: \.lengthState, action: Action.updatedLengthState))

                    CharactersView(store: store.scope(state: \.charactersState, action: Action.updatedCharactersState))

                    PasswordView(store: store.scope(state: \.passwordState, action: Action.updatedPasswordState))
                }
                .padding(spacing)
            }
            .emittingError(viewStore.binding(get: \.error, send: Action.updateError))
            .navigationBarItems(
                trailing: Button(
                    action: { viewStore.send(.logout) },
                    label: {

                        Text(Strings.PasswordGeneratorView.resetMasterPassword)
                            .font(.headline)
                    }
                )
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

#if DEBUG

struct PasswordGeneratorView_Previews: PreviewProvider {

    static let store = Store<PasswordGeneratorView.State, PasswordGeneratorView.Action>(
        initialState: .init(
            configurationState: .init(
                passwordType: .domainBased,
                domainState: .init(
                    username: "",
                    domain: "",
                    seed: .init(
                        title: Strings.PasswordGeneratorView.seed.formatted(),
                        count: 1,
                        bounds: 1 ... 999
                    ),
                    isValid: false
                ),
                serviceState: .init(
                    service: "",
                    isValid: false
                ),
                isValid: false
            ),
            lengthState: .init(
                lengthState: .init(
                    title: Strings.PasswordGeneratorView.passwordLength.formatted(),
                    count: 8,
                    bounds: 4 ... 32
                )
            ),
            charactersState: .init(
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
            passwordState: .init(
                flow: .invalid,
                copyableState: .init(content: "")
            )
        ),
        reducer: PasswordGeneratorView.sharedReducer,
        environment: PasswordGeneratorView.Environment.live()
    )

    static var previews: some View {

        Group {

            PasswordGeneratorView(store: store)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            PasswordGeneratorView(store: store)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView(store: store)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
