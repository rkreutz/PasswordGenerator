import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct LengthView: View {

        let store: Store<State, Action>

        var body: some View {

            CounterView(store: store.scope(state: \.lengthState, action: Action.updatedLengthCounter))
                .asCard()
//            .onChange(of: charactersState) { newValue in
//
//                guard newValue.minimalLength > charactersState.length else { return }
//                charactersState.length = newValue.minimalLength
//            }
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct LengthView_Previews: PreviewProvider {

    static let store: Store<PasswordGeneratorView.LengthView.State, PasswordGeneratorView.LengthView.Action> = .init(
        initialState: .init(
            lengthState: .init(
                title: "Length",
                count: 1,
                bounds: 4 ... 32
            )
        ),
        reducer: PasswordGeneratorView.LengthView.sharedReducer,
        environment: .init()
    )

    static var previews: some View {

        Group {

            PasswordGeneratorView.LengthView(store: store)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
                .padding()
                .previewLayout(.sizeThatFits)

            PasswordGeneratorView.LengthView(store: store)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
                .padding()
                .previewLayout(.sizeThatFits)

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView.LengthView(store: store)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
                    .padding()
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}

#endif
