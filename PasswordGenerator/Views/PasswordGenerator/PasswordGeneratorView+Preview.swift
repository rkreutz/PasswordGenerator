import SwiftUI
import PasswordGeneratorKit

#if DEBUG

struct PasswordGeneratorView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            PasswordGeneratorView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            PasswordGeneratorView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                PasswordGeneratorView()
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
        .use(passwordGenerator: PasswordGenerator(masterPasswordProvider: "masterPassword"))
        .environmentObject(AppState(state: .masterPasswordSet))
    }
}

#endif
