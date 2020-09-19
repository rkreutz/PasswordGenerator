//swiftlint:disable closure_body_length
import SwiftUI

public struct CounterToggleView: View {

    @Binding var toggle: Bool
    var toggleTitle: LocalizedStringKey
    @Binding var count: Int
    var counterTitle: LocalizedStringKey
    var bounds: ClosedRange<Int>

    @ScaledMetric private var spacing: CGFloat = 16

    public var body: some View {

        VStack(spacing: spacing) {

            Toggle(toggleTitle, isOn: $toggle)
                .font(.subheadline)
                .foregroundColor(.foreground)
                .allowsTightening(true)

            if toggle {

                withAnimation(.easeInOut(duration: 0.15)) {

                    CounterView(count: $count,
                                title: counterTitle,
                                bounds: bounds)
                }
            }
        }
        .animation(.easeInOut(duration: 0.15))
    }
}

#if DEBUG

struct CounterToggleView_Previews: PreviewProvider {

    @State static var toggle: Bool = true
    @State static var count: Int = 1

    static var previews: some View {

        Group {

            CounterToggleView(toggle: $toggle,
                              toggleTitle: "Toggle title",
                              count: $count,
                              counterTitle: "Counter title",
                              bounds: 1 ... Int.max)
                .padding()
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            CounterToggleView(toggle: $toggle,
                              toggleTitle: "Toggle title",
                              count: $count,
                              counterTitle: "Counter title",
                              bounds: 1 ... Int.max)
                .padding()
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CounterToggleView(toggle: $toggle,
                                  toggleTitle: "Toggle title",
                                  count: $count,
                                  counterTitle: "Counter title",
                                  bounds: 1 ... Int.max)
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
