import SwiftUI

public struct CounterToggleView: View {

    @Environment(\.sizeCategory) private var sizeCategory

    @Binding private var toggle: Bool
    private var toggleTitle: LocalizedStringKey
    @Binding private var count: Int
    private var counterTitle: LocalizedStringKey
    private var bounds: ClosedRange<Int>

    public init(
        toggle: Binding<Bool>,
        toggleTitle: LocalizedStringKey,
        count: Binding<Int>,
        counterTitle: LocalizedStringKey,
        bounds: ClosedRange<Int>
    ) {

        self._toggle = toggle
        self.toggleTitle = toggleTitle
        self._count = count
        self.counterTitle = counterTitle
        self.bounds = bounds
    }

    public var body: some View {

        VStack(spacing: 16 * sizeCategory.modifier) {

            Toggle(toggleTitle, isOn: $toggle)
                .font(.subheadline)
                .foregroundColor(.foreground)
                .allowsTightening(true)

            if self.toggle {

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
