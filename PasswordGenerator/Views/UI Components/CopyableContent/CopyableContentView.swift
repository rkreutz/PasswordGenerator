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
            #if os(iOS)
            Text(viewStore.content)
                .foregroundColor(.label)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .font(.system(.headline, design: .monospaced))
            #elseif os(macOS)
            if #available(macOS 12, *) {
                Text(viewStore.content)
                    .textSelection(.enabled)
                    .foregroundColor(.label)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.system(.headline, design: .monospaced))
            } else {
                Text(viewStore.content)
                    .foregroundColor(.label)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.system(.headline, design: .monospaced))
            }
            #endif

            Button(
                action: { viewStore.send(.didTapCopyButton) },
                label: {
                    Image(systemName: viewStore.hasCopied ? "checkmark" : "doc.on.clipboard")
                        #if os(iOS)
                        .foregroundColor(.accentColor)
                        .font(.system(.headline, design: .monospaced))
                        #endif
                }
            )
            #if os(iOS)
            .frame(width: buttonWidth, height: buttonHeight)
            #elseif os(macOS)
            .frame(width: buttonWidth)
            #endif
        }
    }
}

#if DEBUG

struct CopyableContentView_Previews: PreviewProvider {

    static var previews: some View {

        CopyableContentView(
            store: .init(
                initialState: .init(content: "Content"),
                reducer: CopyableContent()
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#endif
