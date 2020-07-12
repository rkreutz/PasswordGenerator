import SwiftUI

struct CopyableContentView: View {

    let content: String
    @State var hasCopied = false

    private let workItemReference = DispatchWorkItemReference()
    @Environment(\.sizeCategory) private var sizeCategory
    private let generator = UINotificationFeedbackGenerator()

    var body: some View {

        HStack(spacing: 8 * sizeCategory.modifier) {

            Text(content)
                .foregroundColor(.foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .font(.system(.headline, design: .monospaced))

            Button(
                action: {

                    UIPasteboard.general.string = self.content
                    self.hasCopied = true
                    self.generator.notificationOccurred(.success)

                    let workItem = DispatchWorkItem {

                        self.hasCopied = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
                    self.workItemReference.workItem = workItem
                },
                label: {

                    Image(systemName: hasCopied ? "checkmark" : "doc.on.clipboard")
                        .foregroundColor(.accent)
                        .font(.system(.headline, design: .monospaced))
                }
            )
            .frame(width: 44 * sizeCategory.modifier)
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
