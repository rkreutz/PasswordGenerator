import SwiftUI
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers
import ComposableArchitecture

struct PasswordGeneratorView: View {

    struct ViewState: Equatable {
        var error: Error?

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }

    typealias ViewAction = PasswordGenerator.Action

    @ScaledMetric private var maxWidth: CGFloat = 490

    let store: StoreOf<PasswordGenerator>
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(store: StoreOf<PasswordGenerator>) {
        self.store = store
        self.viewStore = ViewStore(
            store,
            observe: \.view,
            send: { $0 }
        )
    }

    var body: some View {
        #if os(iOS)
        GeometryReader { proxy in
            if proxy.size.width > maxWidth {
                LargeView(store: store)
            } else {
                CompactView(store: store)
            }
        }
        .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
        #elseif os(macOS)
        DesktopView(store: store)
            .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
        #endif
    }
}

private extension PasswordGenerator.State {
    var view: PasswordGeneratorView.ViewState {
        get { .init(error: error) }
        set { error = newValue.error }
    }
}

#if APP
#if DEBUG

struct PasswordGeneratorView_Previews: PreviewProvider {

    static let store = StoreOf<PasswordGenerator>(
        initialState: .init(
            configuration: .init(
                passwordType: .domainBased,
                domain: .init(
                    username: "",
                    domain: "",
                    seed: .init(
                        count: 1,
                        bounds: 1 ... 999
                    )
                ),
                service: .init(
                    service: ""
                )
            ),
            length: .init(
                count: 8,
                bounds: 4 ... 32
            ),
            characters: .init(
                digits: .init(
                    isToggled: true,
                    counter: .init(
                        count: 1,
                        bounds: 1 ... 8
                    )
                ),
                symbols: .init(
                    isToggled: false,
                    counter: .init(
                        count: 0,
                        bounds: 1 ... 8
                    )
                ),
                lowercase: .init(
                    isToggled: true,
                    counter: .init(
                        count: 1,
                        bounds: 1 ... 8
                    )
                ),
                uppercase: .init(
                    isToggled: true,
                    counter: .init(
                        count: 1,
                        bounds: 1 ... 8
                    )
                ),
                shouldUseOptimisedUI: true
            ),
            password: .init(
                flow: .invalid,
                copyableContent: .init(content: "")
            ),
            entropyGenerator: .pbkdf2(iterations: 1_000),
            entropySize: 40,
            shouldUseOptimisedUI: true,
            shouldShowPasswordStrength: true
        ),
        reducer: PasswordGenerator()
    )

    static var previews: some View {
        PasswordGeneratorView(store: store)
    }
}

#endif
#endif
