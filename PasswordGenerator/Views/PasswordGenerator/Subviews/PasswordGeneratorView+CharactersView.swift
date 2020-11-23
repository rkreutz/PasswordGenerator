//swiftlint:disable closure_body_length
import SwiftUI

extension PasswordGeneratorView {

    struct CharactersView: View {

        @Binding var charactersState: CharactersState

        @ScaledMetric private var spacing: CGFloat = 16

        var body: some View {

            VStack(spacing: spacing) {

                CounterToggleView(
                    toggle: true,
                    toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters,
                    count: $charactersState.numberOfLowercase,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: true,
                    toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters,
                    count: $charactersState.numberOfUppercase,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: true,
                    toggleTitle: Strings.PasswordGeneratorView.decimalCharacters,
                    count: $charactersState.numberOfDigits,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: false,
                    toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters,
                    count: $charactersState.numberOfSymbols,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
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
