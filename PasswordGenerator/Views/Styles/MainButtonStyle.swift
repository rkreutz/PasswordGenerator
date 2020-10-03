//swiftlint:disable closure_body_length
import SwiftUI

struct MainButtonStyle: ButtonStyle {

    var isEnabled: Bool
    var spacing: CGFloat

    func makeBody(configuration: Configuration) -> some View {

        let opacity = configuration.isPressed ? 0.5 : 1
        let color = isEnabled ? Color.accentContrast.opacity(opacity) : Color.neutral02.opacity(opacity)

        return configuration.label
            .font(.headline)
            .foregroundColor(color)
            .expandedInParent()
            .padding(spacing)
            .background(
                RoundedRectangle(cornerRadius: spacing, style: .continuous)
                    .foregroundColor(isEnabled ? .accent : .neutral01)
            )
    }
}

private struct MainButtonModifier: ViewModifier {

    @Environment(\.isEnabled) private var isEnabled
    @ScaledMetric private var padding: CGFloat = 16

    func body(content: Content) -> some View {

        content
            .buttonStyle(MainButtonStyle(isEnabled: isEnabled, spacing: padding))
    }
}

extension View {

    func styleAsMainButton() -> some View {

        modifier(MainButtonModifier())
    }
}

#if DEBUG

struct MainButton_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            Button("Button", action: {})
                .styleAsMainButton()
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (enabled)")

            Button("Button", action: {})
                .styleAsMainButton()
                .disabled(true)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (disabled)")

            Button("Button", action: {})
                .styleAsMainButton()
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (enabled)")
                .background(Rectangle().foregroundColor(.background01))
                .environment(\.colorScheme, .dark)

            Button("Button", action: {})
                .styleAsMainButton()
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
