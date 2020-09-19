//swiftlint:disable closure_body_length
import SwiftUI

extension PasswordGeneratorView {

    struct CharactersView: View {

        @Environment(\.sizeCategory) private var sizeCategory

        @EnvironmentObject var viewModel: ViewModel

        var body: some View {

            VStack(spacing: 16 * sizeCategory.modifier) {

                CounterToggleView(
                    toggle: $viewModel.shouldIncludeLowercase,
                    toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters,
                    count: $viewModel.numberOfLowercase,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: $viewModel.shouldIncludeUppercase,
                    toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters,
                    count: $viewModel.numberOfUppercase,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: $viewModel.shouldIncludeDigits,
                    toggleTitle: Strings.PasswordGeneratorView.decimalCharacters,
                    count: $viewModel.numberOfDigits,
                    counterTitle: Strings.PasswordGeneratorView.numberOfCharacters,
                    bounds: 1 ... 8
                )

                SeparatorView()

                CounterToggleView(
                    toggle: $viewModel.shouldIncludeSymbols,
                    toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters,
                    count: $viewModel.numberOfSymbols,
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

            PasswordGeneratorView.CharactersView()
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)

            PasswordGeneratorView.CharactersView()
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.CharactersView()
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, category)
            }
        }
        .use(passwordGenerator: PasswordGenerator(masterPasswordProvider: "masterPassword"))
        .environmentObject(PasswordGeneratorView.ViewModel())
    }
}

#endif
