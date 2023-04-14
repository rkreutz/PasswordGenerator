//swiftlint:disable closure_body_length
import SwiftUI

struct FormButtonStyle: ButtonStyle {

    enum Role {
        case destructive
        case cancel
    }

    let role: Role?

    struct Button: View {

        let style: FormButtonStyle
        let configuration: Configuration

        @ScaledMetric private var minHeight: CGFloat = 44

        var body: some View {
            HStack {
                configuration.label
                    .font(style.role != nil ? Font.body.weight(.semibold) : Font.body)
                    .foregroundColor(style.role == .destructive ? Color.red : Color.accentColor)
                    .frame(minHeight: minHeight)
                    .padding(.horizontal)

                Spacer()
            }
            .background(configuration.isPressed ? Color.systemFill : Color.secondarySystemGroupedBackground)
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        Button(style: self, configuration: configuration)
    }
}
