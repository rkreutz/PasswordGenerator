//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

public struct CounterToggleView: View {

    @ScaledMetric private var spacing: CGFloat = 16

    let store: Store<State, Action>

    public var body: some View {

        WithViewStore(store) { viewStore in

            VStack(spacing: spacing) {

                Toggle(viewStore.toggleTitle, isOn: viewStore.binding(get: \.isToggled, send: Action.updateToggle))
                    .font(.subheadline)
                    .foregroundColor(.label)
                    .allowsTightening(true)

                if viewStore.isToggled {

                    CounterView(store: store.scope(state: \.counterState, action: Action.counterChanged))
                }
            }
            .animation(.easeInOut(duration: 0.15))
        }
    }
}

#if DEBUG

struct CounterToggleView_Previews: PreviewProvider {

    @State static var count: Int = 1

    static var previews: some View {

        Group {

            CounterToggleView(
                store: .init(
                    initialState: CounterToggleView.State(
                        toggleTitle: "Toggle title",
                        isToggled: true,
                        counterState: CounterView.State(
                            title: "Counter title",
                            count: 1,
                            bounds: 1 ... Int.max
                        )
                    ),
                    reducer: CounterToggleView.sharedReducer,
                    environment: CounterToggleView.Environment())
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CounterToggleView(
                store: .init(
                    initialState: CounterToggleView.State(
                        toggleTitle: "Toggle title",
                        isToggled: true,
                        counterState: CounterView.State(
                            title: "Counter title",
                            count: 1,
                            bounds: 1 ... Int.max
                        )
                    ),
                    reducer: CounterToggleView.sharedReducer,
                    environment: CounterToggleView.Environment())
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterToggleView(
                    store: .init(
                        initialState: CounterToggleView.State(
                            toggleTitle: "Toggle title",
                            isToggled: true,
                            counterState: CounterView.State(
                                title: "Counter title",
                                count: 1,
                                bounds: 1 ... Int.max
                            )
                        ),
                        reducer: CounterToggleView.sharedReducer,
                        environment: CounterToggleView.Environment())
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
