import ComposableArchitecture
import Foundation
import SwiftUI

struct OptimisedUITutorial: Reducer {

    struct State: Equatable {
        var counterToggle: CounterToggle.State = .init(isToggled: false, counter: .init(count: 0, bounds: 1 ... 8))
        var message: LocalizedStringKey = Strings.OptimisedUITutorialView.charactersViewStep1
    }

    enum Action: Equatable {
        case counterToggle(CounterToggle.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.counterToggle, action: /Action.counterToggle) { CounterToggle() }
        Reduce { state, action in
            switch action {
            case .counterToggle(.set(\.$isToggled, false)):
                state.message = Strings.OptimisedUITutorialView.charactersViewStep1
                return .none

            case .counterToggle(.set(\.$isToggled, true)):
                state.message = Strings.OptimisedUITutorialView.charactersViewStep2
                return .none

            case .counterToggle(.counter(.binding(\.$count))):
                if state.counterToggle.counter.count > 1 {
                    state.message = Strings.OptimisedUITutorialView.charactersViewStep3
                }
                return .none

            default:
                return .none
            }
        }
    }
}
