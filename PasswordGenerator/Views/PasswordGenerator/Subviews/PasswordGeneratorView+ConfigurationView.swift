import SwiftUI
import ComposableArchitecture

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
                        store: .init(
                            initialState: CounterView.State(title: Strings.PasswordGeneratorView.seed.formatted(), count: configurationState.seed, bounds: 1 ... 999),
                            reducer: CounterView.Reducer.combine(
                                CounterView.sharedReducer,
                                CounterView.Reducer { state, action, _ -> Effect<CounterView.Action, Never> in

                                    switch action {

                                    case let .counterUpdated(count):
                                        configurationState.seed = count
                                        return .none
                                    }
                                }
                            ),
                            environment: CounterView.Environment()
                        )
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
