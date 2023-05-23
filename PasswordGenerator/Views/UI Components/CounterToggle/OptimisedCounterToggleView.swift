//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

public struct OptimisedCounterToggleView: View {

    typealias ViewState = CounterToggle.State
    typealias ViewAction = CounterToggle.Action

    @ScaledMetric private var padding: CGFloat = 16
    @ScaledMetric private var cornerRadius: CGFloat = 12

    let title: LocalizedStringKey
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(title: LocalizedStringKey, store: StoreOf<CounterToggle>) {
        self.title = title
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    public var body: some View {
        Text(title)
            .foregroundColor(viewStore.state.isToggled ? .white : .secondaryLabel)
            .padding(.horizontal, padding)
            .padding(.vertical, padding / 2)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .foregroundColor(viewStore.state.isToggled ? .accentColor : .disabledBackgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(viewStore.state.isToggled ? .accentColor : .disabledBorderColor)

            )
            .onTapGesture { viewStore.send(.set(\.$isToggled, !viewStore.state.isToggled)) }
            .contextMenu {
                if viewStore.state.isToggled {
                    VStack {
                        ForEach(viewStore.state.counter.bounds, id: \.self) { value in
                            Button(Strings.PasswordGeneratorView.characters(value), action: { viewStore.send(.counter(.set(\.$count, value))) })
                        }
                    }
                }
            }
            .badge(if: viewStore.isToggled && viewStore.counter.count > 1, count: viewStore.counter.count)
    }
}

private extension Color {
    static let disabledBackgroundColor: Color = {
        #if os(iOS)
        .secondarySystemBackground
        #else
        .control
        #endif
    }()

    static let disabledBorderColor: Color = {
        #if os(iOS)
        .tertiarySystemBackground
        #else
        .separator
        #endif
    }()
}

#if DEBUG

struct OptimisedCounterToggleView_Previews: PreviewProvider {

    @State static var count: Int = 1

    static var previews: some View {

        OptimisedCounterToggleView(
            title: "ABC...",
            store: .init(
                initialState: .init(
                    isToggled: true,
                    counter: .init(
                        count: 8,
                        bounds: 1 ... 8
                    )
                ),
                reducer: CounterToggle()
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#endif
