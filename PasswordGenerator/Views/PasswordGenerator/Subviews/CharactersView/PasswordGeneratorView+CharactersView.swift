import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct CharactersView: View {

        @ScaledMetric private var spacing: CGFloat = 16

        let store: Store<State, Action>

        var body: some View {

            VStack(spacing: spacing) {

                CounterToggleView(store: store.scope(state: \.lowercaseState, action: Action.updatedLowercaseCounter))

                SeparatorView()

                CounterToggleView(store: store.scope(state: \.uppercaseState, action: Action.updatedUppercaseCounter))

                SeparatorView()

                CounterToggleView(store: store.scope(state: \.digitsState, action: Action.updatedDigitsCounter))

                SeparatorView()

                CounterToggleView(store: store.scope(state: \.symbolsState, action: Action.updatedSymbolsCounter))
            }
            .asCard()
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct CharactersView_Previews: PreviewProvider {

    static let store: Store<PasswordGeneratorView.CharactersView.State, PasswordGeneratorView.CharactersView.Action> = .init(
        initialState: .init(
            digitsState: .init(
                toggleTitle: "Digits",
                isToggled: true,
                counterState: .init(
                    title: "Number",
                    count: 1,
                    bounds: 1 ... 8
                )
            ),
            symbolsState: .init(
                toggleTitle: "Symbols",
                isToggled: false,
                counterState: .init(
                    title: "Number",
                    count: 0,
                    bounds: 1 ... 8
                )
            ),
            lowercaseState: .init(
                toggleTitle: "Lowercase",
                isToggled: true,
                counterState: .init(
                    title: "Number",
                    count: 1,
                    bounds: 1 ... 8
                )
            ),
            uppercaseState: .init(
                toggleTitle: "Uppercase",
                isToggled: true,
                counterState: .init(
                    title: "Number",
                    count: 1,
                    bounds: 1 ... 8
                )
            ),
            isValid: true
        ),
        reducer: PasswordGeneratorView.CharactersView.sharedReducer,
        environment: PasswordGeneratorView.CharactersView.Environment()
    )

    static var previews: some View {

        Group {

            PasswordGeneratorView.CharactersView(store: store)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)

            PasswordGeneratorView.CharactersView(store: store)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.CharactersView(store: store)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, category)
            }
        }
    }
}

#endif
