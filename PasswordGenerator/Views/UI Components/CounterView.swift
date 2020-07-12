import SwiftUI

public struct CounterView: View {

    @Environment(\.sizeCategory) private var sizeCategory

    @Binding private var count: Int
    private var title: LocalizedStringKey
    private var bounds: ClosedRange<Int>

    public init(count: Binding<Int>, title: LocalizedStringKey, bounds: ClosedRange<Int>) {

        self._count = count
        self.title = title
        self.bounds = bounds
    }

    public var body: some View {

        Stepper(value: $count, in: bounds) {

            HStack(alignment: .center) {

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.foreground)
                    .allowsTightening(true)

                Spacer(minLength: 8 * sizeCategory.modifier)

                Text("\(self.count)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.foreground)
                    .layoutPriority(1)
            }
            .padding(.trailing, 8 * sizeCategory.modifier)
        }
    }
}

#if DEBUG

struct CounterView_Previews: PreviewProvider {

    @State static var count: Int = 99

    static var previews: some View {

        Group {

            CounterView(count: $count, title: "Title", bounds: 1 ... Int.max)
                .padding()
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            CounterView(count: $count, title: "Title", bounds: 1 ... Int.max)
                .padding()
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterView(count: $count, title: "Counter Title", bounds: 1 ... Int.max)
                    .padding()
                    .background(Rectangle().foregroundColor(.background02))
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
