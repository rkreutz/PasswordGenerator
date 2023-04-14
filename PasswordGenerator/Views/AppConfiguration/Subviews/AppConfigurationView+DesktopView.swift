import ComposableArchitecture
import SwiftUI

extension AppConfigurationView {
    struct DesktopView: View {

        private enum Constants {
            static let helpIconName = "questionmark.circle.fill"
        }

        let store: StoreOf<AppConfiguration>
        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        @ScaledMetric private var minWidth: CGFloat = 300
        @ScaledMetric private var spacing: CGFloat = 24

        var body: some View {
            VStack(alignment: .leading) {
                GroupedBox(
                    title: Strings.AppConfigurationView.entropyConfigurationSectionTitle,
                    help: Strings.AppConfigurationView.entropyConfigurationSectionDescription,
                    content: {
                        VStack(alignment: .leading) {
                            GeneratorPicker(store: store)

                            GeneratorTextField(
                                title: Strings.AppConfigurationView.iterationsTitle,
                                store: store,
                                \.$iterations
                            )

                            switch viewStore.derivationAlgorithm {
                            case .argon:
                                GeneratorTextField(
                                    title: Strings.AppConfigurationView.memoryTitle,
                                    store: store,
                                    \.$memory
                                )
                                GeneratorTextField(
                                    title: Strings.AppConfigurationView.threadsTitle,
                                    store: store,
                                    \.$threads
                                )
                            case .pbkdf:
                                EmptyView()
                            }

                            SeparatorView()

                            EntropySizePicker(store: store)
                        }
                        .padding()
                    }
                )
                .padding(.bottom, spacing)

                if #available(macOS 12.0, *) {
                    Button(Strings.AppConfigurationView.clearMasterPasswordTitle) {
                        viewStore.send(.didTapResetMasterPassword)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.systemRed)
                } else {
                    Button(Strings.AppConfigurationView.clearMasterPasswordTitle) {
                        viewStore.send(.didTapResetMasterPassword)
                    }
                }

                Spacer()
            }
            .frame(minWidth: minWidth)
            .padding()
        }
    }
}
