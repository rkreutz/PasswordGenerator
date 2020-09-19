//swiftlint:disable closure_body_length
import SwiftUI

struct MainButton: View {

    @Environment(\.isEnabled) private var isEnabled
    @ScaledMetric var spacing: CGFloat = 16

    let action: () -> Void
    let text: LocalizedStringKey

    var body: some View {

        Button(
            action: action,
            label: {

                Text(text)
                    .font(.headline)
                    .foregroundColor(isEnabled ? .accentContrast : .neutral02)
                    .expandedInParent()
                    .padding(spacing)
            }
        )
        .disabled(!isEnabled)
        .background(
            RoundedRectangle(
                cornerRadius: spacing,
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

            MainButton(action: {}, text: "Button")
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (enabled)")

            MainButton(action: {}, text: "Button")
                .disabled(true)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (disabled)")

            MainButton(action: {}, text: "Button")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (enabled)")
                .background(Rectangle().foregroundColor(.background01))
                .environment(\.colorScheme, .dark)

            MainButton(action: {}, text: "Button")
                .disabled(true)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (disabled)")
                .background(Rectangle().foregroundColor(.background01))
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif
