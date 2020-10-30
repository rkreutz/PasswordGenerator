import SwiftUI

extension PasswordGeneratorView {

    struct LengthView: View {

        @Binding var charactersState: CharactersState

        var body: some View {

            CounterView(
                count: $charactersState.length,
                title: Strings.PasswordGeneratorView.passwordLength,
                bounds: charactersState.minimalLength ... 32
            )
            .onChange(of: charactersState) { newValue in

                guard newValue.minimalLength > charactersState.length else { return }
                charactersState.length = newValue.minimalLength
            }
            .asCard()
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct LengthView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView.LengthView(charactersState: .init(.init()))
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.LengthView(charactersState: .init(.init()))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.LengthView(charactersState: .init(.init()))
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}

#endif
