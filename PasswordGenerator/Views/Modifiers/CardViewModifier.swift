import SwiftUI

#if os(iOS)
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
#endif

extension View {

    func asCard() -> some View {
        #if os(iOS)
        modifier(CardViewModifier())
        #elseif os(macOS)
        GroupedBox { self.padding() }
        #endif
    }
}
