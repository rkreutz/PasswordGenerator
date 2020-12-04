import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct ConfigurationView: View {

        @ScaledMetric private var spacing: CGFloat = 16

        let store: Store<State, Action>

        var body: some View {

            WithViewStore(store) { viewStore in

                VStack(alignment: .center, spacing: spacing) {

                    Picker(selection: viewStore.binding(get: \.passwordType, send: Action.updatePasswordType), label: Text("")) {

                        ForEach(PasswordType.allCases, id: \.hashValue) { passwordType in

                            Text(passwordType.title)
                                .tag(passwordType)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .fixedSize()

                    switch viewStore.passwordType {

                    case .domainBased:
                        PasswordGeneratorView.DomainView(store: store.scope(state: \.domainState, action: Action.updateDomain))

                    case .serviceBased:
                        PasswordGeneratorView.ServiceView(store: store.scope(state: \.serviceState, action: Action.updateService))
                    }
                }
                .asCard()
                .textFieldStyle(SecondaryTextFiledStyle())
                .disableAutocorrection(true)
            }
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct ConfigurationView_Previews: PreviewProvider {

    static let store: Store<PasswordGeneratorView.ConfigurationView.State, PasswordGeneratorView.ConfigurationView.Action> = .init(
        initialState: .init(
            passwordType: .domainBased,
            domainState: .init(
                username: "username",
                domain: "google.com",
                seed: .init(
                    title: "Seed",
                    count: 1,
                    bounds: 1 ... 999
                ),
                isValid: true
            ),
            serviceState: .init(
                service: "Service",
                isValid: true
            ),
            isValid: true
        ),
        reducer: PasswordGeneratorView.ConfigurationView.sharedReducer,
        environment: .init()
    )

    static var previews: some View {

        Group {

            PasswordGeneratorView.ConfigurationView(store: store)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.ConfigurationView(store: store)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.ConfigurationView(store: store)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}

#endif
