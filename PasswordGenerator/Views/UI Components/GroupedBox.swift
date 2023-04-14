import SwiftUI

private enum Constants {
    static let helpIconName = "questionmark.circle.fill"
}

struct GroupedBox<Content: View>: View {

    var title: LocalizedStringKey?
    var help: LocalizedStringKey?
    @ViewBuilder let content: () -> Content

    var body: some View {
        if #available(macOS 12, *) {
            GroupBox(
                content: { content() },
                label: {
                    switch (title, help) {
                    case let (.some(title), .none):
                        Text(title)

                    case (.none, _):
                        EmptyView()

                    case let (.some(title), .some(help)):
                        HStack {
                            Text(title).help(help)

                            Image(systemName: Constants.helpIconName)
                                .foregroundColor(.secondaryLabel)
                                .help(help)
                        }
                    }
                }
            )
        } else {
            VStack(alignment: .leading, spacing: 2) {
                switch (title, help) {
                case let (.some(title), .none):
                    Text(title)
                        .font(.subheadline)
                        .padding(.horizontal, 8)

                case (.none, _):
                    EmptyView()

                case let (.some(title), .some(help)):
                    HStack {
                        Text(title)
                            .font(.subheadline)
                            .help(help)

                        Image(systemName: Constants.helpIconName)
                            .font(.subheadline)
                            .foregroundColor(.secondaryLabel)
                            .help(help)
                    }
                    .padding(.horizontal, 8)
                }

                content()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color.control.opacity(0.2))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.separator, lineWidth: 1)
                    )
            }
        }
    }
}
