//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

public struct CounterView: View {

    @ScaledMetric private var spacing: CGFloat = 8

    let store: Store<State, Action>

    public var body: some View {

        WithViewStore(store) { viewStore in

            Stepper(value: viewStore.binding(get: \.count, send: Action.update), in: viewStore.bounds) {

                HStack(alignment: .center) {

                    Text(viewStore.title)
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
}

#if DEBUG

struct CounterView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            CounterView(
                store: Store(
                    initialState: CounterView.State(title: "Title", count: 99, bounds: 1 ... Int.max),
                    reducer: CounterView.sharedReducer,
                    environment: CounterView.Environment()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CounterView(
                store: Store(
                    initialState: CounterView.State(title: "Title", count: 99, bounds: 1 ... Int.max),
                    reducer: CounterView.sharedReducer,
                    environment: CounterView.Environment()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterView(
                    store: Store(
                        initialState: CounterView.State(title: "Title", count: 99, bounds: 1 ... Int.max),
                        reducer: CounterView.sharedReducer,
                        environment: CounterView.Environment()
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
