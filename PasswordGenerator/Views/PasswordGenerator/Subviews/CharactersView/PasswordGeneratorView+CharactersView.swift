import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct CharactersView: View {

        typealias ViewState = PasswordGenerator.Characters.State
        typealias ViewAction = PasswordGenerator.Characters.Action

        @ScaledMetric private var spacing: CGFloat = 16

        let store: Store<ViewState, ViewAction>

        var body: some View {
            #if os(iOS)
            WithViewStore(store.actionless, observe: { $0.shouldUseOptimisedUI }) { viewStore in
                if viewStore.state {
                    HStack {
                        OptimisedCounterToggleView(
                            title: Strings.PasswordGeneratorView.lowercasedCharacters,
                            store: store.scope(state: \.lowercase, action: ViewAction.lowercase)
                        )

                        OptimisedCounterToggleView(
                            title: Strings.PasswordGeneratorView.uppercasedCharacters,
                            store: store.scope(state: \.uppercase, action: ViewAction.uppercase)
                        )

                        OptimisedCounterToggleView(
                            title: Strings.PasswordGeneratorView.decimalCharacters,
                            store: store.scope(state: \.digits, action: ViewAction.digits)
                        )

                        OptimisedCounterToggleView(
                            title: Strings.PasswordGeneratorView.symbolsCharacters,
                            store: store.scope(state: \.symbols, action: ViewAction.symbols)
                        )
                    }
                    .allowsTightening(true)
                    .lineLimit(1)
                    .expandedInParent()
                    .asCard()
                } else {
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
            #elseif os(macOS)
            HStack {
                CounterToggleView(
                    title: Strings.PasswordGeneratorView.lowercasedCharacters,
                    counterTitle: "",
                    store: store.scope(state: \.lowercase, action: ViewAction.lowercase)
                )
                .expandedInParent()
                .help(Strings.PasswordGeneratorView.lowercasedCharactersTooltip)

                SeparatorView(axis: .vertical)

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.uppercasedCharacters,
                    counterTitle: "",
                    store: store.scope(state: \.uppercase, action: ViewAction.uppercase)
                )
                .expandedInParent()
                .help(Strings.PasswordGeneratorView.uppercasedCharactersTooltip)

                SeparatorView(axis: .vertical)

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.decimalCharacters,
                    counterTitle: "",
                    store: store.scope(state: \.digits, action: ViewAction.digits)
                )
                .expandedInParent()
                .help(Strings.PasswordGeneratorView.decimalCharactersTooltip)

                SeparatorView(axis: .vertical)

                CounterToggleView(
                    title: Strings.PasswordGeneratorView.symbolsCharacters,
                    counterTitle: "",
                    store: store.scope(state: \.symbols, action: ViewAction.symbols)
                )
                .expandedInParent()
                .help(Strings.PasswordGeneratorView.symbolsCharactersTooltip)
            }
            #endif
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
            ),
            shouldUseOptimisedUI: true
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
