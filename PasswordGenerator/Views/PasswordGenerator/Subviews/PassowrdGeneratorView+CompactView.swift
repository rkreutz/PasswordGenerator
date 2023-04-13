import ComposableArchitecture
import SwiftUI

extension PasswordGeneratorView {
    struct CompactView: View {

        @ScaledMetric private var spacing: CGFloat = 16

        let store: StoreOf<PasswordGenerator>

        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: spacing) {
                    ConfigurationView(store: store.scope(state: \.configuration, action: ViewAction.configuration))

                    LengthView(store: store.scope(state: \.length, action: ViewAction.length))

                    CharactersView(store: store.scope(state: \.characters, action: ViewAction.characters))

                    PasswordView(store: store.scope(state: \.password, action: ViewAction.password))
                }
                .padding(spacing)
            }
        }
    }
}
