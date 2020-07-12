import SwiftUI

private struct Toast<Presenter: View, Content: View>: View {

    @Binding var isShowing: Bool

    let presenting: () -> Presenter
    let content: () -> Content
    let duration: TimeInterval

    @Environment(\.sizeCategory) private var sizeCategory
    private let workItemReference = DispatchWorkItemReference()

    var body: some View {

        if isShowing {

            let workItem = DispatchWorkItem {

                self.isShowing = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
            workItemReference.workItem = workItem
        }

        return GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()

                VStack {

                    Spacer()
                        .frame(height: 12 / self.sizeCategory.modifier)

                    self.content()
                        .padding(.vertical, 8 / self.sizeCategory.modifier)
                        .padding(.horizontal, 24 / self.sizeCategory.modifier)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 12 * self.sizeCategory.modifier,
                                style: .continuous
                            )
                            .foregroundColor(.foreground)
                            .opacity(0.85)
                            .blur(radius: 1)
                        )
                        .offset(x: 0, y: self.isShowing ? 0 : -UIScreen.main.bounds.height)
                        .animation(.default)
                        .frame(maxWidth: geometry.size.width * 0.8)

                    Spacer()
                }
            }
        }

    }
}

extension View {

    func toast<Content: View>(isShowing: Binding<Bool>,
                              duration: TimeInterval = 5.0,
                              @ViewBuilder _ content: @escaping () -> Content) -> some View {

        Toast(
            isShowing: isShowing,
            presenting: { self },
            content: content,
            duration: duration
        )
    }

    func toast(text: Binding<LocalizedStringKey?>, duration: TimeInterval = 5.0) -> some View {

        let isShowing = Binding(
            get: { text.wrappedValue != nil },
            set: {

                guard !$0 else { return }
                text.wrappedValue = nil
            }
        )

        return Toast(
            isShowing: isShowing,
            presenting: { self },
            content: {

                Text(text.wrappedValue ?? "")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.background01)
            },
            duration: duration
        )
    }

    func toast(text: Binding<String?>, duration: TimeInterval = 5.0) -> some View {

        let isShowing = Binding(
            get: { text.wrappedValue != nil },
            set: {

                guard !$0 else { return }
                text.wrappedValue = nil
            }
        )

        return Toast(
            isShowing: isShowing,
            presenting: { self },
            content: {

                Text(text.wrappedValue ?? "")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.background01)
            },
            duration: duration
        )
    }
}

#if DEBUG

struct ToastView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            Text("Text")
                .toast(text: Binding<String?>("My Toast" as String?))
                .background(
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.background01)
                )
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            Text("Text")
                .toast(text: Binding<String?>("My Toast" as String?))
                .background(
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.background01)
                )
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
        }
    }
}

#endif
