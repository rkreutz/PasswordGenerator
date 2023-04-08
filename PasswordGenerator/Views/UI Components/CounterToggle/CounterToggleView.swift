//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

public struct CounterToggleView: View {
    
    struct ViewState: Equatable {
        @BindingState var isToggled: Bool
    }
    
    enum ViewAction: BindableAction, Equatable {
        case binding(BindingAction<ViewState>)
        
        var domainAction: CounterToggle.Action {
            switch self {
            case .binding(let action):
                return .binding(action.pullback(\.view))
            }
        }
    }
    
    @ScaledMetric private var spacing: CGFloat = 16

    let title: LocalizedStringKey
    let counterTitle: LocalizedStringKey
    let store: StoreOf<CounterToggle>
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>
    
    init(title: LocalizedStringKey, counterTitle: LocalizedStringKey, store: StoreOf<CounterToggle>) {
        self.title = title
        self.counterTitle = counterTitle
        self.store = store
        self.viewStore = ViewStore(
            store,
            observe: \.view,
            send: \.domainAction
        )
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            Toggle(title, isOn: viewStore.binding(\.$isToggled))
                .font(.subheadline)
                .foregroundColor(.label)
                .allowsTightening(true)
            
            if viewStore.isToggled {
                CounterView(title: counterTitle, store: store.scope(state: \.counter, action: CounterToggle.Action.counter))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: viewStore.isToggled)
    }
}

private extension CounterToggle.State {
    var view: CounterToggleView.ViewState {
        get { .init(isToggled: isToggled) }
        set { isToggled = newValue.isToggled }
    }
}

#if DEBUG

struct CounterToggleView_Previews: PreviewProvider {

    @State static var count: Int = 1

    static var previews: some View {

        Group {

            CounterToggleView(
                title: "Toggle title",
                counterTitle: "Counter title",
                store: .init(
                    initialState: .init(
                        isToggled: true,
                        counter: .init(
                            count: 1,
                            bounds: 1 ... Int.max
                        )
                    ),
                    reducer: CounterToggle()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CounterToggleView(
                title: "Toggle title",
                counterTitle: "Counter title",
                store: .init(
                    initialState: .init(
                        isToggled: true,
                        counter: .init(
                            count: 1,
                            bounds: 1 ... Int.max
                        )
                    ),
                    reducer: CounterToggle()
                )
            )
            .padding()
            .background(Rectangle().foregroundColor(.secondarySystemBackground))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterToggleView(
                    title: "Toggle title",
                    counterTitle: "Counter title",
                    store: .init(
                        initialState: .init(
                            isToggled: true,
                            counter: .init(
                                count: 1,
                                bounds: 1 ... Int.max
                            )
                        ),
                        reducer: CounterToggle()
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
