import SwiftUI
import UIKit
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
        GeometryReader { proxy in
            if proxy.size.width > maxWidth {
                LargeView(store: store)
            } else {
                CompactView(store: store)
            }
        }
        .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
    }
}

private extension PasswordGenerator.State {
    var view: PasswordGeneratorView.ViewState {
        get { .init(error: error) }
        set { error = newValue.error }
    }
}

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
                )
            ),
            password: .init(
                flow: .invalid,
                copyableContent: .init(content: "")
            ),
            entropyGenerator: .pbkdf2(iterations: 1_000),
            entropySize: 40
        ),
        reducer: PasswordGenerator()
    )

    static var previews: some View {

        Group {

            PasswordGeneratorView(store: store)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            PasswordGeneratorView(store: store)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView(store: store)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
