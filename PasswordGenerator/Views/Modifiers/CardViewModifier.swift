import SwiftUI

struct CardViewModifier: ViewModifier {

    @ScaledMetric private var margin: CGFloat = 16

    func body(content: Content) -> some View {

        content
            .padding(margin)
            .background(
                RoundedRectangle(
                    cornerRadius: margin,
                    style: .continuous
                )
                .foregroundColor(.background02)
            )
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {

    func asCard() -> some View {

        modifier(CardViewModifier())
    }
}
