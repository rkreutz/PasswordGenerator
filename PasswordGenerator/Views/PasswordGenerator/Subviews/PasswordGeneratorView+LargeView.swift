import ComposableArchitecture
import SwiftUI

extension PasswordGeneratorView {
    struct LargeView: View {

        @ScaledMetric private var spacing: CGFloat = 16

        let store: StoreOf<PasswordGenerator>

        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: spacing) {
                    HStack(alignment: .top, spacing: spacing) {
                        WithViewStore(store, observe: \.shouldUseOptimisedUI) { viewStore in
                            if viewStore.state {
                                ConfigurationView(store: store.scope(state: \.configuration, action: ViewAction.configuration))

                                VStack(alignment: .center, spacing: spacing) {
                                    LengthView(store: store.scope(state: \.length, action: ViewAction.length))

                                    CharactersView(store: store.scope(state: \.characters, action: ViewAction.characters))

                                    #if APP
                                    WithViewStore(store, observe: { $0.shouldShowPasswordStrength }) { viewStore in
                                        if viewStore.state {
                                            PasswordEntropyView(store: store.actionless.scope(state: \.passwordEntropy))
                                        }
                                    }
                                    #endif
                                }
                            } else {
                                VStack(alignment: .center, spacing: spacing) {
                                    ConfigurationView(store: store.scope(state: \.configuration, action: ViewAction.configuration))

                                    LengthView(store: store.scope(state: \.length, action: ViewAction.length))

                                    #if APP
                                    WithViewStore(store, observe: { $0.shouldShowPasswordStrength }) { viewStore in
                                        if viewStore.state {
                                            PasswordEntropyView(store: store.actionless.scope(state: \.passwordEntropy))
                                        }
                                    }
                                    #endif
                                }

                                CharactersView(store: store.scope(state: \.characters, action: ViewAction.characters))
                            }
                        }
                    }

                    PasswordView(store: store.scope(state: \.password, action: ViewAction.password))
                }
                .padding(spacing)
            }
        }
    }
}
