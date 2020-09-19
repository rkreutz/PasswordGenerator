//swiftlint:disable closure_body_length
import SwiftUI

struct CopyableContentView: View {

    let content: String
    @State var hasCopied = false

    @ScaledMetric private var spacing: CGFloat = 8
    @ScaledMetric private var buttonWidth: CGFloat = 44

    private let workItemReference = DispatchWorkItemReference()
    private let generator = UINotificationFeedbackGenerator()

    var body: some View {

        HStack(spacing: spacing) {

            Text(content)
                .foregroundColor(.foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .font(.system(.headline, design: .monospaced))

            Button(
                action: {

                    UIPasteboard.general.string = content
                    hasCopied = true
                    generator.notificationOccurred(.success)

                    let workItem = DispatchWorkItem {

                        hasCopied = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
                    workItemReference.workItem = workItem
                },
                label: {

                    Image(systemName: hasCopied ? "checkmark" : "doc.on.clipboard")
                        .foregroundColor(.accent)
                        .font(.system(.headline, design: .monospaced))
                }
            )
            .frame(width: buttonWidth)
        }
    }
}

#if DEBUG

struct CopyableContentView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            CopyableContentView(content: "Content")
                .padding()
                .background(Rectangle().foregroundColor(.background01))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            CopyableContentView(content: "Content")
                .padding()
                .background(Rectangle().foregroundColor(.background01))
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            CopyableContentView(content: "Content", hasCopied: true)
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Copied")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                CopyableContentView(content: "Content")
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
