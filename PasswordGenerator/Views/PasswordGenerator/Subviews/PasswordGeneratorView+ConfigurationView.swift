import SwiftUI

extension PasswordGeneratorView {

    struct ConfigurationView: View {

        @Environment(\.sizeCategory) private var sizeCategory

        @EnvironmentObject var viewModel: ViewModel

        var body: some View {

            CardView {

                VStack(alignment: .center, spacing: 16 * sizeCategory.modifier) {

                    TextField(Strings.PasswordGeneratorView.username, text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.foreground)
                        .font(.body)

                    SeparatorView()

                    TextField(Strings.PasswordGeneratorView.domain, text: $viewModel.domain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                        .foregroundColor(.foreground)
                        .font(.body)

                    SeparatorView()

                    CounterView(
                        count: $viewModel.seed,
                        title: Strings.PasswordGeneratorView.seed,
                        bounds: 1 ... 999
                    )
                }
            }
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct ConfigurationView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView.ConfigurationView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.ConfigurationView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.ConfigurationView()
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
