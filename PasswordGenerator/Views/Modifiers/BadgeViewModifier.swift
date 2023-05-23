import SwiftUI

struct BadgeViewModifier: ViewModifier {

    let count: Int

    @ScaledMetric private var padding = 5

    func body(content: Content) -> some View {
        content
            .overlay(
                Text(String(count))
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(padding)
                    .background(Color.systemRed)
                    .clipShape(Circle())
                    .alignmentGuide(.top) { $0[.bottom] - $0.height * 0.6 }
                    .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 },
                alignment: .topTrailing
            )
    }
}

extension View {
    func badge(count: Int) -> some View {
        modifier(BadgeViewModifier(count: count))
    }

    @ViewBuilder func badge(if condition: Bool, count: Int) -> some View {
        if condition {
            self.badge(count: count)
        } else {
            self
        }
    }
}

#if DEBUG

@available(iOS 15.0, *)
struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 40, height: 40)
            .badge(count: 4)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

#endif
