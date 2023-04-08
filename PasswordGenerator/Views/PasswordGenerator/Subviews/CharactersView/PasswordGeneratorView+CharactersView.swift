import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct CharactersView: View {

        typealias ViewState = PasswordGenerator.Characters.State
        typealias ViewAction = PasswordGenerator.Characters.Action

        @ScaledMetric private var spacing: CGFloat = 16

        let store: Store<ViewState, ViewAction>

        var body: some View {
            VStack(spacing: spacing) {
                CounterToggleView(
                    title: Strings.PasswordGeneratorView.lowercasedCharacters,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    store: store.scope(state: \.lowercase, action: ViewAction.lowercase)
                )

                SeparatorView()

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.uppercasedCharacters,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    store: store.scope(state: \.uppercase, action: ViewAction.uppercase)
                )

                SeparatorView()

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.decimalCharacters,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    store: store.scope(state: \.digits, action: ViewAction.digits)
                )

                SeparatorView()

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.symbolsCharacters,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    store: store.scope(state: \.symbols, action: ViewAction.symbols)
                )
            }
            .asCard()
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct CharactersView_Previews: PreviewProvider {

    static let store: Store<PasswordGeneratorView.CharactersView.ViewState, PasswordGeneratorView.CharactersView.ViewAction> = .init(
        initialState: .init(
            digits: .init(
                isToggled: true,
                counter: .init(
                    count: 1,
                    bounds: 1 ... 8
                )
            ),
            symbols: .init(
                isToggled: false,
                counter: .init(
                    count: 0,
                    bounds: 1 ... 8
                )
            ),
            lowercase: .init(
                isToggled: true,
                counter: .init(
                    count: 1,
                    bounds: 1 ... 8
                )
            ),
            uppercase: .init(
                isToggled: true,
                counter: .init(
                    count: 1,
                    bounds: 1 ... 8
                )
            )
        ),
        reducer: PasswordGenerator.Characters()
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
