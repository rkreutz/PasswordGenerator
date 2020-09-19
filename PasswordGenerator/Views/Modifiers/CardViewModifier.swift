import SwiftUI

struct CardViewModifier: ViewModifier {

    @Environment(\.sizeCategory) private var sizeCategory

    func body(content: Content) -> some View {

        content
            .padding(16 * sizeCategory.modifier)
            .background(
                RoundedRectangle(
                    cornerRadius: 16 * sizeCategory.modifier,
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
