//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

struct CopyableContentView: View {

    typealias ViewState = CopyableContent.State

    enum ViewAction: Equatable {
        case didTapCopyButton

        var domainAction: CopyableContent.Action {
            switch self {
            case .didTapCopyButton:
                return .didTapCopyButton
            }
        }
    }

    @ScaledMetric private var spacing: CGFloat = 8
    @ScaledMetric private var buttonWidth: CGFloat = 44
    @ScaledMetric private var buttonHeight: CGFloat = 24

    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(store: StoreOf<CopyableContent>) {
        self.viewStore = ViewStore(
            store,
            observe: { $0 },
            send: \.domainAction
        )
    }

    var body: some View {
        HStack(spacing: spacing) {
            Text(viewStore.content)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .font(.system(.headline, design: .monospaced))

            Button(
                action: { viewStore.send(.didTapCopyButton) },
                label: {
                    Image(systemName: viewStore.hasCopied ? "checkmark" : "doc.on.clipboard")
                        .foregroundColor(.accentColor)
                        .font(.system(.headline, design: .monospaced))
                }
            )
            .frame(width: buttonWidth, height: buttonHeight)
        }
    }
}

#if DEBUG

struct CopyableContentView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            CopyableContentView(
                store: .init(
                    initialState: .init(content: "Content"),
                    reducer: CopyableContent()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.systemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CopyableContentView(
                store: .init(
                    initialState: .init(content: "Content"),
                    reducer: CopyableContent()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.systemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            CopyableContentView(
                store: .init(
                    initialState: .init(content: "Content", hasCopied: true),
                    reducer: CopyableContent()
                )
            )
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Copied")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CopyableContentView(
                    store: .init(
                        initialState: .init(content: "Content"),
                        reducer: CopyableContent()
                    )
                )
                .padding()
                .background(Rectangle().foregroundColor(.systemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, category)
                .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
