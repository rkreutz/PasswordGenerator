import SwiftUI

extension PasswordGeneratorView {

    struct LengthView: View {

        @EnvironmentObject private var viewModel: ViewModel

        var body: some View {

            CounterView(
                count: $viewModel.length,
                title: Strings.PasswordGeneratorView.passwordLength,
                bounds: viewModel.minimalLength ... 32
            )
            .asCard()
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct LengthView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView.LengthView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.LengthView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.LengthView()
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
            }
        }
        .use(passwordGenerator: PasswordGenerator(masterPasswordProvider: "masterPassword"))
        .environmentObject(PasswordGeneratorView.ViewModel())
    }
}

#endif
