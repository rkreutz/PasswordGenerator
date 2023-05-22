import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {
    struct PasswordEntropyView: View {
        typealias ViewState = PasswordGenerator.PasswordEntropy.State
        typealias ViewAction = PasswordGenerator.PasswordEntropy.Action

        let store: Store<ViewState, ViewAction>

        var body: some View {
            WithViewStore(store, observe: { $0 }) { viewStore in
                #if os(macOS)
                GroupedBox(
                    title: Strings.PasswordGeneratorView.passwordStrengthTitle,
                    help: Strings.PasswordGeneratorView.passwordStrengthTooltip,
                    content: {
                        VStack(alignment: .leading) {
                            EntropyBarView(entropy: viewStore.actualEntropy)

                            if viewStore.isEntropyGeneratorOverflowed {
                                Label(Strings.PasswordGeneratorView.entropyGeneratorOverflowTitle, systemImage: "exclamationmark.triangle")
                                    .help(Strings.PasswordGeneratorView.entropyGeneratorOverflowTooltip)
                            }
                        }
                        .padding(.horizontal)
                    }
                )
                #else
                VStack {
                    EntropyBarView(entropy: viewStore.actualEntropy)

                    if viewStore.isEntropyGeneratorOverflowed {
                        Text(Strings.PasswordGeneratorView.entropyGeneratorOverflowTooltip)
                            .font(.caption)
                    }
                }
                .asCard()
                #endif
            }
        }
    }
}
