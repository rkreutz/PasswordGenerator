//swiftlint:disable closure_body_length
import SwiftUI

struct MainButton: View {

    @Environment(\.sizeCategory) private var sizeCategory

    let action: () -> Void
    let text: LocalizedStringKey
    let isEnabled: Bool

    var body: some View {

        Button(
            action: action,
            label: {

                HStack {

                    Spacer()

                    Text(text)
                        .font(.headline)
                        .foregroundColor(isEnabled ? .accentContrast : .neutral02)

                    Spacer()
                }
                .padding(16 * sizeCategory.modifier)
            }
        )
        .disabled(!isEnabled)
        .background(
            RoundedRectangle(
                cornerRadius: 16 * sizeCategory.modifier,
                style: .continuous
            )
            .foregroundColor(isEnabled ? .accent : .neutral01)
        )
    }
}

#if DEBUG

struct MainButton_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            MainButton(action: {}, text: "Button", isEnabled: true)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (enabled)")

            MainButton(action: {}, text: "Button", isEnabled: false)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (disabled)")

            MainButton(action: {}, text: "Button", isEnabled: true)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (enabled)")
                .background(Rectangle().foregroundColor(.background01))
                .environment(\.colorScheme, .dark)

            MainButton(action: {}, text: "Button", isEnabled: false)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (disabled)")
                .background(Rectangle().foregroundColor(.background01))
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif
