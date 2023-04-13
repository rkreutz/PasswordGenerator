import SwiftUI

struct ExpandInParentViewModifier: ViewModifier {

    enum Axis {

        case horizontal
        case vertical
    }

    var axis: Axis

    func body(content: Content) -> some View {

        switch axis {

        case .horizontal:
            return HStack {

                Spacer()

                content

                Spacer()
            }.asAny()

        case .vertical:
            return VStack {

                Spacer()

                content

                Spacer()
            }.asAny()
        }
    }
}

extension View {

    func expandedInParent(_ axis: ExpandInParentViewModifier.Axis = .horizontal) -> some View {

        modifier(ExpandInParentViewModifier(axis: axis))
    }
}
