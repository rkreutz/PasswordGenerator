//swiftlint:disable closure_body_length
import SwiftUI

extension PasswordGeneratorView {

    struct ConfigurationView: View {

        @Binding var configurationState: ConfigurationState

        @ScaledMetric private var spacing: CGFloat = 16

        var body: some View {

            VStack(alignment: .center, spacing: spacing) {

                Picker(selection: $configurationState.passwordType, label: Text("")) {

                    ForEach(PasswordType.allCases, id: \.hashValue) { passwordType in

                        Text(passwordType.title)
                            .tag(passwordType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .fixedSize()

                switch configurationState.passwordType {

                case .domainBased:
                    TextField(Strings.PasswordGeneratorView.username, text: $configurationState.username)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SeparatorView()

                    TextField(Strings.PasswordGeneratorView.domain, text: $configurationState.domain)
                        .autocapitalization(.none)
                        .keyboardType(.URL)

                    SeparatorView()

                    CounterView(
                        count: $configurationState.seed,
                        title: Strings.PasswordGeneratorView.seed,
                        bounds: 1 ... 999
                    )

                case .serviceBased:
                    TextField(Strings.PasswordGeneratorView.service, text: $configurationState.service)
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

            PasswordGeneratorView.ConfigurationView(configurationState: .init(.init()))
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.ConfigurationView(configurationState: .init(.init()))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.ConfigurationView(configurationState: .init(.init()))
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}

#endif
