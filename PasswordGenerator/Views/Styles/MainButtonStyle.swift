//swiftlint:disable closure_body_length
import SwiftUI

struct MainButtonStyle: ButtonStyle {

    struct Button: View {

        let configuration: Configuration

        @Environment(\.isEnabled) private var isEnabled
        @ScaledMetric private var padding: CGFloat = 16

        var body: some View {

            configuration.label
                #if os(iOS)
                .font(.headline)
                .foregroundColor(isEnabled ? Color.white.opacity(configuration.isPressed ? 0.5 : 1) : Color.systemGray4)
                #elseif os(macOS)
                .foregroundColor(isEnabled ? Color.white.opacity(configuration.isPressed ? 0.5 : 1) : Color.disabledControlText)
                #endif
                .expandedInParent()
                .padding(padding)
                .background(
                    RoundedRectangle(cornerRadius: padding, style: .continuous)
                        #if os(iOS)
                        .foregroundColor(isEnabled ? .accentColor : .systemGray)
                        #elseif os(macOS)
                        .foregroundColor(isEnabled ? .accentColor : .controlBackground)
                        #endif
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

        Button("Button", action: {})
            .buttonStyle(MainButtonStyle())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

#endif
