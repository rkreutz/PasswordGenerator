import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct ConfigurationView: View {

        typealias ViewState = BindingState<PasswordGenerator.Configuration.PasswordType>

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            var domainAction: PasswordGenerator.Configuration.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(\.$passwordType))
                }
            }
        }

        @ScaledMetric private var spacing: CGFloat = 16

        let store: StoreOf<PasswordGenerator.Configuration>
        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<PasswordGenerator.Configuration>) {
            self.store = store
            self.viewStore = ViewStore(
                store,
                observe: \.$passwordType,
                send: \.domainAction
            )
        }

        var body: some View {
            VStack(alignment: .center, spacing: spacing) {
                Picker(Strings.PasswordGeneratorView.passwordType, selection: viewStore.binding(\.self)) {
                    Text(Strings.PasswordGeneratorView.domainBased).tag(PasswordGenerator.Configuration.PasswordType.domainBased)
                    Text(Strings.PasswordGeneratorView.serviceBased).tag(PasswordGenerator.Configuration.PasswordType.serviceBased)
                }
                #if os(iOS)
                .pickerStyle(SegmentedPickerStyle())
                .fixedSize()
                #endif

                switch viewStore.wrappedValue {
                case .domainBased:
                    PasswordGeneratorView.DomainView(store: store.scope(state: \.domain, action: PasswordGenerator.Configuration.Action.domain))

                case .serviceBased:
                    PasswordGeneratorView.ServiceView(store: store.scope(state: \.service, action: PasswordGenerator.Configuration.Action.service))
                }
            }
            #if os(iOS)
            .asCard()
            .textFieldStyle(SecondaryTextFiledStyle())
            #endif
            .disableAutocorrection(true)
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct ConfigurationView_Previews: PreviewProvider {

    static let store: StoreOf<PasswordGenerator.Configuration> = .init(
        initialState: .init(
            passwordType: .domainBased,
            domain: .init(
                username: "username",
                domain: "google.com",
                seed: .init(
                    count: 1,
                    bounds: 1 ... 999
                )
            ),
            service: .init(
                service: "Service"
            )
        ),
        reducer: PasswordGenerator.Configuration()
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
