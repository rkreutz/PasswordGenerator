import SwiftUI

struct ParagraphStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.title
            .foregroundColor(Color.foreground)
            .font(.body)
            .multilineTextAlignment(.leading)
    }
}
