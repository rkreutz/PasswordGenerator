import SwiftUI

public struct CounterView: View {

    @Binding var count: Int
    var title: LocalizedStringKey
    var bounds: ClosedRange<Int>

    @ScaledMetric private var spacing: CGFloat = 8

    public var body: some View {

        Stepper(value: $count, in: bounds) {

            HStack(alignment: .center) {

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.label)
                    .allowsTightening(true)

                Spacer(minLength: spacing)

                Text("\(count)")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.label)
                    .layoutPriority(1)
            }
            .padding(.trailing, spacing)
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
                .background(Rectangle().foregroundColor(.secondarySystemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            CounterView(count: $count, title: "Title", bounds: 1 ... Int.max)
                .padding()
                .background(Rectangle().foregroundColor(.secondarySystemBackground))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterView(count: $count, title: "Counter Title", bounds: 1 ... Int.max)
                    .padding()
                    .background(Rectangle().foregroundColor(.secondarySystemBackground))
                    .previewLayout(.sizeThatFits)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
