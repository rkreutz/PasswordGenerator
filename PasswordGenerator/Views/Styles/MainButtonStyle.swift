//swiftlint:disable closure_body_length
import SwiftUI

struct MainButtonStyle: ButtonStyle {

    struct Button: View {

        let configuration: Configuration

        @Environment(\.isEnabled) private var isEnabled
        @ScaledMetric private var padding: CGFloat = 16

        var body: some View {

            configuration.label
                .font(.headline)
                .foregroundColor(isEnabled ? Color.white.opacity(configuration.isPressed ? 0.5 : 1) : Color.systemGray4)
                .expandedInParent()
                .padding(padding)
                .background(
                    RoundedRectangle(cornerRadius: padding, style: .continuous)
                        .foregroundColor(isEnabled ? .accentColor : .systemGray)
                )
        }
    }

    func makeBody(configuration: Configuration) -> some View {

        Button(configuration: configuration)
    }
}

#if DEBUG

struct MainButton_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            Button("Button", action: {})
                .buttonStyle(MainButtonStyle())
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (enabled)")

            Button("Button", action: {})
                .buttonStyle(MainButtonStyle())
                .disabled(true)
                .environment(\.colorScheme, .light)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light (disabled)")

            Button("Button", action: {})
                .buttonStyle(MainButtonStyle())
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (enabled)")
                .background(Rectangle().foregroundColor(.systemBackground))
                .environment(\.colorScheme, .dark)

            Button("Button", action: {})
                .buttonStyle(MainButtonStyle())
                .disabled(true)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Dark (disabled)")
                .background(Rectangle().foregroundColor(.systemBackground))
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif
