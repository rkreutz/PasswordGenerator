import SwiftUI

struct ParagraphStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.title
            .foregroundColor(Color.primary)
            .font(.body)
            .multilineTextAlignment(.leading)
    }
}
