//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

struct OptimisedUITutorialView: View {

    typealias ViewState = OptimisedUITutorial.State
    typealias ViewAction = OptimisedUITutorial.Action

    let store: StoreOf<OptimisedUITutorial>
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    @ScaledMetric private var spacing = 64

    init(store: StoreOf<OptimisedUITutorial>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        VStack(spacing: spacing) {
            OptimisedCounterToggleView(
                title: Strings.OptimisedUITutorialView.characterFamily,
                store: store.scope(state: \.counterToggle, action: ViewAction.counterToggle)
            )

            Text(viewStore.message)
                .multilineTextAlignment(.center)
                .font(.title3)

            Spacer()
        }
        .padding()
    }
}
