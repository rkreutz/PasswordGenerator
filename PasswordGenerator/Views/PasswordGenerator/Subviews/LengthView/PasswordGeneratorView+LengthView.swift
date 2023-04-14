import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct LengthView: View {

        typealias ViewState = PasswordGenerator.Length.State
        typealias ViewAction = PasswordGenerator.Length.Action

        let store: Store<ViewState, ViewAction>

        var body: some View {
            CounterView(title: Strings.PasswordGeneratorView.passwordLength, store: store)
            #if os(iOS)
                .asCard()
            #endif
        }
    }
}

#if DEBUG

import PasswordGeneratorKit

struct LengthView_Previews: PreviewProvider {

    static let store: Store<PasswordGeneratorView.LengthView.ViewState, PasswordGeneratorView.LengthView.ViewAction> = .init(
        initialState: .init(
            count: 1,
            bounds: 4 ... 32
        ),
        reducer: PasswordGenerator.Length()
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
