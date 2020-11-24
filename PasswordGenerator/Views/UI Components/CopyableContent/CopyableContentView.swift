import SwiftUI
import ComposableArchitecture

struct CopyableContentView: View {

    @ScaledMetric private var spacing: CGFloat = 8
    @ScaledMetric private var buttonWidth: CGFloat = 44

    let store: Store<State, Action>

    var body: some View {

        WithViewStore(store) { viewStore in

            HStack(spacing: spacing) {

                Text(viewStore.content)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.system(.headline, design: .monospaced))

                Button(
                    action: { viewStore.send(.copyContent) },
                    label: {

                        Image(systemName: viewStore.hasCopied ? "checkmark" : "doc.on.clipboard")
                            .foregroundColor(.accentColor)
                            .font(.system(.headline, design: .monospaced))
                    }
                )
                .frame(width: buttonWidth)
            }
        }
    }
}

#if DEBUG

struct CopyableContentView_Previews: PreviewProvider {

    static var previews: some View {

        //swiftlint:disable:next closure_body_length
        Group {

            CopyableContentView(
                store: Store(
                    initialState: CopyableContentView.State(content: "Content"),
                    reducer: CopyableContentView.sharedReducer,
                    environment: CopyableContentView.Environment.live()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.systemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CopyableContentView(
                store: Store(
                    initialState: CopyableContentView.State(content: "Content"),
                    reducer: CopyableContentView.sharedReducer,
                    environment: CopyableContentView.Environment.live()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.systemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            CopyableContentView(
                store: Store(
                    initialState: CopyableContentView.State(content: "Content", hasCopied: true),
                    reducer: CopyableContentView.sharedReducer,
                    environment: CopyableContentView.Environment.live()
                )
            )
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Copied")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CopyableContentView(
                    store: Store(
                        initialState: CopyableContentView.State(content: "Content"),
                        reducer: CopyableContentView.sharedReducer,
                        environment: CopyableContentView.Environment.live()
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
