//swiftlint:disable closure_body_length
import SwiftUI

extension PasswordGeneratorView {

    struct CharactersView: View {

        @Binding var charactersState: CharactersState

        @ScaledMetric private var spacing: CGFloat = 16

        var body: some View {

            VStack(spacing: spacing) {

                CounterToggleView(
                    store: .init(
                        initialState: CounterToggleView.State(
                            toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters.formatted(),
                            isToggled: true,
                            counterState: CounterView.State(
                                title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                count: charactersState.numberOfLowercase,
                                bounds: 1 ... 8
                            )
                        ),
                        reducer: CounterToggleView.sharedReducer,
                        environment: CounterToggleView.Environment())
                )

                SeparatorView()

                CounterToggleView(
                    store: .init(
                        initialState: CounterToggleView.State(
                            toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters.formatted(),
                            isToggled: true,
                            counterState: CounterView.State(
                                title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                count: charactersState.numberOfUppercase,
                                bounds: 1 ... 8
                            )
                        ),
                        reducer: CounterToggleView.sharedReducer,
                        environment: CounterToggleView.Environment())
                )

                SeparatorView()

                CounterToggleView(
                    store: .init(
                        initialState: CounterToggleView.State(
                            toggleTitle: Strings.PasswordGeneratorView.decimalCharacters.formatted(),
                            isToggled: true,
                            counterState: CounterView.State(
                                title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                count: charactersState.numberOfDigits,
                                bounds: 1 ... 8
                            )
                        ),
                        reducer: CounterToggleView.sharedReducer,
                        environment: CounterToggleView.Environment())
                )

                SeparatorView()

                CounterToggleView(
                    store: .init(
                        initialState: CounterToggleView.State(
                            toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters.formatted(),
                            isToggled: false,
                            counterState: CounterView.State(
                                title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                count: charactersState.numberOfSymbols,
                                bounds: 1 ... 8
                            )
                        ),
                        reducer: CounterToggleView.sharedReducer,
                        environment: CounterToggleView.Environment())
                )
            }
            .asCard()
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct CharactersView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView.CharactersView(charactersState: .init(.init()))
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)

            PasswordGeneratorView.CharactersView(charactersState: .init(.init()))
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.CharactersView(charactersState: .init(.init()))
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, category)
            }
        }
    }
}

#endif
