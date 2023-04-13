//swiftlint:disable closure_body_length
import SwiftUI

struct FormButtonStyle: ButtonStyle {

    struct Button: View {

        let configuration: Configuration

        @ScaledMetric private var minHeight: CGFloat = 44

        var body: some View {
            HStack {
                configuration.label
                    .font(configuration.role != nil ? Font.body.weight(.semibold) : Font.body)
                    .foregroundColor(configuration.role == .destructive ? Color.red : Color.accentColor)
                    .frame(minHeight: minHeight)
                    .padding(.horizontal)

                Spacer()
            }
            .background(configuration.isPressed ? Color.systemFill : Color.secondarySystemGroupedBackground)
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration)
    }
}
