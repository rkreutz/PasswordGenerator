import ComposableArchitecture
import SwiftUI

extension AppConfigurationView {
    struct MobileView: View {
        let store: StoreOf<AppConfiguration>
        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        @ScaledMetric private var maxWidth: CGFloat = 490
        @ScaledMetric private var spacing: CGFloat = 16
        @ScaledMetric private var headerSpacing: CGFloat = 4

        var body: some View {
            NavigationView {
                GeometryReader { proxy in
                    ScrollView {
                        FormSection {
                            Button(Strings.AppConfigurationView.clearMasterPasswordTitle) {
                                viewStore.send(.didTapResetMasterPassword)
                            }
                            .buttonStyle(FormButtonStyle(role: .destructive))
                        }

                        FormSection(
                            content: {
                                VStack(spacing: 0) {
                                    WithViewStore(store, observe: \.shouldUseOptimisedUI) { viewStore in
                                        Toggle(
                                            Strings.AppConfigurationView.useOptimisedUITitle,
                                            isOn: viewStore.binding(
                                                get: { $0 },
                                                send: { AppConfiguration.Action.set(\.$shouldUseOptimisedUI, $0) }
                                            )
                                        )
                                        .padding()

                                        if viewStore.state {
                                            SeparatorView()
                                                .padding(.horizontal)

                                            NavigationLinkStore(
                                                store.scope(state: \.$optimisedUITutorial, action: AppConfiguration.Action.optimisedUITutorial),
                                                onTap: { viewStore.send(.didTapOptimisedUITutorial) },
                                                destination: OptimisedUITutorialView.init(store:),
                                                label: {
                                                    HStack {
                                                        Text(Strings.AppConfigurationView.optimisedUITutorialTitle)
                                                            .foregroundColor(.label)

                                                        Spacer()

                                                        Image(systemName: "chevron.right")
                                                            .foregroundColor(.secondaryLabel)
                                                    }
                                                    .padding()
                                                }
                                            )
                                        }
                                    }

                                    SeparatorView()
                                        .padding(.horizontal)

                                    WithViewStore(store, observe: { $0.shouldShowPasswordStrength }) { viewStore in
                                        Toggle(
                                            Strings.AppConfigurationView.showPasswordStrengthTitle,
                                            isOn: viewStore.binding(
                                                get: { $0 },
                                                send: { AppConfiguration.Action.set(\.$shouldShowPasswordStrength, $0) }
                                            )
                                        )
                                        .padding()
                                    }
                                }
                            },
                            header: {
                                Text(Strings.AppConfigurationView.appConfigTitle)
                                    .padding(.horizontal)
                            },
                            footer: {
                                Text(Strings.AppConfigurationView.passwordStrengthFooter)
                                    .padding(.horizontal)
                            }
                        )

                        FormSection(
                            content: {
                                VStack(alignment: .leading) {
                                    GeneratorTextField(
                                        title: Strings.AppConfigurationView.iterationsTitle,
                                        store: store,
                                        \.$iterations
                                    )
                                    SeparatorView()
                                    switch viewStore.derivationAlgorithm {
                                    case .argon:
                                        GeneratorTextField(
                                            title: Strings.AppConfigurationView.memoryTitle,
                                            store: store,
                                            \.$memory
                                        )
                                        SeparatorView()
                                        GeneratorTextField(
                                            title: Strings.AppConfigurationView.threadsTitle,
                                            store: store,
                                            \.$threads
                                        )
                                        SeparatorView()
                                    case .pbkdf:
                                        EmptyView()
                                    }
                                    EntropySizePicker(store: store)
                                }
                                .padding()
                            },
                            header: {
                                VStack(alignment: .leading, spacing: headerSpacing) {
                                    Text(Strings.AppConfigurationView.entropyConfigurationSectionTitle).padding(.horizontal)
                                    GeneratorPicker(store: store)
                                }
                            },
                            footer: { Text(Strings.AppConfigurationView.entropyConfigurationSectionDescription).padding(.horizontal) }
                        )
                    }
                    .padding([.horizontal], max((proxy.size.width - maxWidth) / 2, 0))
                    .background(
                        Rectangle()
                            .foregroundColor(.systemGroupedBackground)
                            .edgesIgnoringSafeArea(.all)
                    )
                    .scrollDismissesKeyboard(viewStore: viewStore)
                }
            }
        }
    }
}

private extension View {
    func scrollDismissesKeyboard(viewStore: ViewStore<AppConfigurationView.ViewState, AppConfigurationView.ViewAction>) -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            return scrollDismissesKeyboard(.interactively)
        } else {
            return simultaneousGesture(DragGesture().onChanged { _ in viewStore.send(.didScrollView) })
        }
    }
}
