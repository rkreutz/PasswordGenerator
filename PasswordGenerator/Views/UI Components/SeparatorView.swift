import SwiftUI

struct SeparatorView: View {

    enum Axis {
        case horizontal
        case vertical
    }

    var axis: Axis = .horizontal

    @ScaledMetric private var strokeWidth: CGFloat = 1

    var body: some View {

        switch axis {
        case .horizontal:
            Rectangle()
                #if os(iOS)
                .foregroundColor(.systemFill)
                #elseif os(macOS)
                .foregroundColor(.separator)
                #endif
                .frame(height: strokeWidth)

        case .vertical:
            Rectangle()
                #if os(iOS)
                .foregroundColor(.systemFill)
                #elseif os(macOS)
                .foregroundColor(.separator)
                #endif
                .frame(width: strokeWidth)
        }
    }
}

#if DEBUG

struct SeparatorView_Previews: PreviewProvider {

    static var previews: some View {

        SeparatorView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

#endif
