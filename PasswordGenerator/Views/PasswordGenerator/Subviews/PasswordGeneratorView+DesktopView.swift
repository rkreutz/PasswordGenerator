import ComposableArchitecture
import SwiftUI

extension PasswordGeneratorView {
    struct DesktopView: View {

        let store: StoreOf<PasswordGenerator>

        @ScaledMetric private var minWidth: CGFloat = 320
        @ScaledMetric private var thresholdWidth: CGFloat = 650
        @ScaledMetric private var charactersBoxHeight: CGFloat = 172
        @ScaledMetric private var spacing: CGFloat = 16
        @ScaledMetric private var charactersSpacing: CGFloat = 24
        
        var body: some View {
            GeometryReader { proxy in
                if proxy.size.width > thresholdWidth {
                    VStack(spacing: spacing) {
                        HStack(alignment: .top, spacing: spacing) {
                            GroupedBox {
                                ConfigurationView(store: store.scope(state: \.configuration, action: ViewAction.configuration))
                                    .padding()
                            }
                            
                            GroupedBox {
                                VStack(spacing: charactersSpacing) {
                                    LengthView(store: store.scope(state: \.length, action: ViewAction.length))

                                    SeparatorView()

                                    CharactersView(store: store.scope(state: \.characters, action: ViewAction.characters))
                                }
                                .padding()
                            }
                            .frame(height: charactersBoxHeight)
                        }

                        PasswordView(store: store.scope(state: \.password, action: ViewAction.password))

                        Spacer()
                    }
                } else {
                    VStack(spacing: spacing) {
                        GroupedBox {
                            ConfigurationView(store: store.scope(state: \.configuration, action: ViewAction.configuration))
                                .padding()
                        }

                        GroupedBox {
                            VStack(spacing: charactersSpacing) {
                                LengthView(store: store.scope(state: \.length, action: ViewAction.length))

                                SeparatorView()

                                CharactersView(store: store.scope(state: \.characters, action: ViewAction.characters))
                            }
                            .padding()
                        }
                        .frame(height: charactersBoxHeight)

                        PasswordView(store: store.scope(state: \.password, action: ViewAction.password))

                        Spacer()
                    }
                    .frame(minWidth: minWidth)
                }
            }
            .padding()
        }
    }
}
