//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

public struct CounterView: View {

    typealias ViewState = Counter.State
    typealias ViewAction = Counter.Action

    @ScaledMetric private var spacing: CGFloat = 8

    let title: LocalizedStringKey
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(title: LocalizedStringKey, store: StoreOf<Counter>) {
        self.title = title
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    public var body: some View {
        Stepper(value: viewStore.binding(\.$count), in: viewStore.bounds) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.label)
                    .allowsTightening(true)

                Spacer(minLength: spacing)

                Text("\(viewStore.count)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.label)
                    .layoutPriority(1)
            }
            .padding(.trailing, spacing)
        }
    }
}

#if DEBUG

struct CounterView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            CounterView(
                title: "Title",
                store: StoreOf<Counter>(
                    initialState: Counter.State(count: 99, bounds: 1 ... Int.max),
                    reducer: Counter()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CounterView(
                title: "Title",
                store: StoreOf<Counter>(
                    initialState: Counter.State(count: 99, bounds: 1 ... Int.max),
                    reducer: Counter()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterView(
                    title: "Title",
                    store: StoreOf<Counter>(
                        initialState: Counter.State(count: 99, bounds: 1 ... Int.max),
                        reducer: Counter()
                    )
                )
                .padding()
                .background(Rectangle().foregroundColor(.secondarySystemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, category)
                .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
