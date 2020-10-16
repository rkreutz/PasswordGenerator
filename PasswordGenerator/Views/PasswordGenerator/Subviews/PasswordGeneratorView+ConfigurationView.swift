//swiftlint:disable closure_body_length
import SwiftUI

extension PasswordGeneratorView {

    struct ConfigurationView: View {

        @ScaledMetric private var spacing: CGFloat = 16
        @EnvironmentObject private var viewModel: ViewModel

        var body: some View {

            VStack(alignment: .center, spacing: spacing) {

                Picker(selection: $viewModel.passwordType, label: Text("")) {

                    ForEach(PasswordType.allCases, id: \.hashValue) { passwordType in

                        Text(passwordType.title)
                            .tag(passwordType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .fixedSize()

                switch viewModel.passwordType {

                case .domainBased:
                    TextField(Strings.PasswordGeneratorView.username, text: $viewModel.username)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SeparatorView()

                    TextField(Strings.PasswordGeneratorView.domain, text: $viewModel.domain)
                        .autocapitalization(.none)
                        .keyboardType(.URL)

                    SeparatorView()

                    CounterView(
                        count: $viewModel.seed,
                        title: Strings.PasswordGeneratorView.seed,
                        bounds: 1 ... 999
                    )

                case .serviceBased:
                    TextField(Strings.PasswordGeneratorView.service, text: $viewModel.service)
                        .autocapitalization(.sentences)
                        .keyboardType(.default)
                }
            }
            .asCard()
            .textFieldStyle(SecondaryTextFiledStyle())
            .disableAutocorrection(true)
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
