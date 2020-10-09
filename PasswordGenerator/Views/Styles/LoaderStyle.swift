import SwiftUI

struct LoaderStyle: ProgressViewStyle {

    func makeBody(configuration: Configuration) -> some View {

        VStack {

            Loader()

            configuration.label
        }
    }
}

private struct Loader: View {

    @State private var isAnimating: Bool = false

    var body: some View {

        GeometryReader { (geometry: GeometryProxy) in

            ForEach(0 ..< 5) { index in

                Group {

                    Circle()
                        .foregroundColor(.accent)
                        .frame(
                            width: geometry.size.minLength * 0.2,
                            height: geometry.size.minLength * 0.2
                        )
                        .scaleEffect(1 - CGFloat(index) / 5)
                        .offset(y: geometry.size.minLength * 0.125 - geometry.size.height / 2)
                }
                .frame(width: geometry.size.minLength, height: geometry.size.minLength)
                .rotationEffect(!isAnimating ? .degrees(0) : .degrees(360))
                .animation(
                    Animation
                        .timingCurve(
                            0.5 * Double(index) / 5,
                            0,
                            1 - 0.5 * (1 - Double(index) / 5),
                            1,
                            duration: 1.2
                        )
                        .repeatForever(autoreverses: false)
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear { isAnimating = true }
    }
}

#if DEBUG

struct Loader_Previews: PreviewProvider {
    
    static var previews: some View {

        Group {

            Loader()
                .frame(width: 375, height: 80)
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            Loader()
                .frame(width: 375, height: 80)
                .background(Rectangle().foregroundColor(.background02))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
        }
    }
}

#endif
