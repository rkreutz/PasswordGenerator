import SwiftUI

struct SeparatorView: View {

    @ScaledMetric private var height: CGFloat = 1

    var body: some View {

        Rectangle()
            .foregroundColor(.systemFill)
            .frame(height: height)
    }
}

#if DEBUG

struct SeparatorView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            SeparatorView()
                .padding()
                .background(Rectangle().foregroundColor(.secondarySystemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            SeparatorView()
                .padding()
                .background(Rectangle().foregroundColor(.secondarySystemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
        }
    }
}

#endif
