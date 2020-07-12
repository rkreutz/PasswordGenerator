import SwiftUI

struct CardView<Content: View>: View {

    @Environment(\.sizeCategory) private var sizeCategory

    private var content: Content

    init(@ViewBuilder _ content: () -> Content) {

        self.content = content()
    }

    var body: some View {

        ZStack {

            RoundedRectangle(
                cornerRadius: 16 * sizeCategory.modifier,
                style: .continuous
            )

            content
                .padding(16 * sizeCategory.modifier)

        }
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(.background02)
    }
}

#if DEBUG

struct CardView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            CardView {

                Text("Something")
                    .foregroundColor(.foreground)
            }
            .padding()
            .background(Rectangle().foregroundColor(.background01))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            CardView {

                Text("Something")
                    .foregroundColor(.foreground)
            }
            .padding()
            .background(Rectangle().foregroundColor(.background01))
            .previewLayout(.sizeThatFits)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CardView {

                    Text("Something")
                        .foregroundColor(.foreground)
                }
                .padding()
                .background(Rectangle().foregroundColor(.background01))
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, category)
                .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
