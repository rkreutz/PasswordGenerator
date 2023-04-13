import SwiftUI

struct CardViewModifier: ViewModifier {

    @ScaledMetric private var margin: CGFloat = 16

    func body(content: Content) -> some View {

        content
            .padding(margin)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: margin,
                    style: .continuous
                )
            )
            .background(
                RoundedRectangle(
                    cornerRadius: margin,
                    style: .continuous
                )
                .foregroundColor(.secondarySystemBackground)
            )
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {

    func asCard() -> some View {

        modifier(CardViewModifier())
    }
}
