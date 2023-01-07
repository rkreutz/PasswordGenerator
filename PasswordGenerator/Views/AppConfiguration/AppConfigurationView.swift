//swiftlint:disable closure_body_length
import SwiftUI
import PasswordGeneratorKit
import ComposableArchitecture

// 67rPedZC - pbkdf
// YCX5Qq2t - argon
struct AppConfigurationView: View {

    enum KeyDerivationAlgorithm {
        case pbkdf
        case argon
    }

    @ScaledMetric private var spacing: CGFloat = 16

    let store: Store<State, Action>
    
    var body: some View {

        WithViewStore(store) { viewStore in

            Form {

                Section {

                    Button(Strings.AppConfigurationView.clearMasterPasswordTitle) {
                        viewStore.send(.resetMasterPasswordTapped)
                    }
                    .foregroundColor(.red)
                }

                Section(
                    content: {

                        Picker(
                            Strings.AppConfigurationView.keyDerivationTitle,
                            selection: viewStore.binding(
                                get: { (state: State) -> KeyDerivationAlgorithm in

                                    switch state.entropyGenerator {

                                    case .pbkdf2:
                                        return .pbkdf

                                    case .argon2:
                                        return .argon
                                    }
                                },
                                send: { (algorithm: KeyDerivationAlgorithm) -> Action in

                                    switch algorithm {

                                    case .pbkdf:
                                        return Action.entropyGeneratorUpdated(.pbkdf2())

                                    case .argon:
                                        return Action.entropyGeneratorUpdated(.argon2())
                                    }
                                }
                            )
                        ) {

                            Text(Strings.AppConfigurationView.pbkdfTitle).tag(KeyDerivationAlgorithm.pbkdf)

                            Text(Strings.AppConfigurationView.argonTitle).tag(KeyDerivationAlgorithm.argon)
                        }
                        .pickerStyle(.segmented)

                        HStack(spacing: spacing) {
                            Text(Strings.AppConfigurationView.iterationsTitle)

                            Spacer()

                            TextField(
                                "",
                                text: viewStore.binding(
                                    get: { (state: State) -> String in

                                        switch state.entropyGenerator {

                                        case .pbkdf2(let iterations):
                                            return "\(iterations)"

                                        case .argon2(let iterations, _, _):
                                            return "\(iterations)"
                                        }
                                    },
                                    send: { value -> Action in

                                        guard let iterations = UInt(value) else { return Action.entropyGeneratorIterationsUpdated(0) }
                                        return Action.entropyGeneratorIterationsUpdated(iterations)
                                    }
                                )
                            )
                            .fixedSize()
                            .keyboardType(.numberPad)
                        }

                        switch viewStore.entropyGenerator {
                        case .argon2:
                            HStack(spacing: spacing) {
                                Text(Strings.AppConfigurationView.memoryTitle)

                                Spacer()

                                TextField(
                                    "",
                                    text: viewStore.binding(
                                        get: { (state: State) -> String in

                                            switch state.entropyGenerator {

                                            case .pbkdf2:
                                                return "-"

                                            case .argon2(_, let memory, _):
                                                return "\(memory)"
                                            }
                                        },
                                        send: { value -> Action in

                                            guard let memory = UInt(value) else { return Action.entropyGeneratorMemoryUpdated(0) }
                                            return Action.entropyGeneratorMemoryUpdated(memory)
                                        }
                                    )
                                )
                                .fixedSize()
                                .keyboardType(.numberPad)
                            }

                            HStack(spacing: spacing) {
                                Text(Strings.AppConfigurationView.threadsTitle)

                                Spacer()

                                TextField(
                                    "",
                                    text: viewStore.binding(
                                        get: { (state: State) -> String in

                                            switch state.entropyGenerator {

                                            case .pbkdf2:
                                                return "-"

                                            case .argon2(_, _, let threads):
                                                return "\(threads)"
                                            }
                                        },
                                        send: { value -> Action in

                                            guard let threads = UInt(value) else { return Action.entropyGeneratorThreadsUpdated(0) }
                                            return Action.entropyGeneratorThreadsUpdated(threads)
                                        }
                                    )
                                )
                                .fixedSize()
                                .keyboardType(.numberPad)
                            }

                        case .pbkdf2:
                            EmptyView()
                        }

                        HStack(spacing: spacing) {

                            Text(Strings.AppConfigurationView.entropySizeTitle)

                            Spacer()

                            Picker(Strings.AppConfigurationView.entropySizeTitle, selection: viewStore.binding(get: \.entropySize, send: Action.entropySizeUpdated)) {

                                Text("24").tag(24 as UInt)

                                Text("32").tag(32 as UInt)

                                Text("40").tag(40 as UInt)

                                Text("48").tag(48 as UInt)

                                Text("56").tag(56 as UInt)

                                Text("64").tag(64 as UInt)
                            }
                            .pickerStyle(.menu)
                        }
                    },
                    header: {
                        Text(Strings.AppConfigurationView.entropyConfigurationSectionTitle)
                    },
                    footer: {
                        Text(Strings.AppConfigurationView.entropyConfigurationSectionDescription)
                    }
                )
            }
            .simultaneousGesture(DragGesture().onChanged { _ in
                viewStore.send(.shouldDismissKeyboard)
            })
            .emittingError(viewStore.binding(get: \.error, send: Action.updateError))
        }
    }
}
