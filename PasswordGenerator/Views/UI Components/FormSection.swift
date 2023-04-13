import SwiftUI

struct FormSection<Content: View, Header: View, Footer: View>: View {

    let content: () -> Content
    let header: () -> Header
    let footer: () -> Footer

    init(@ViewBuilder content: @escaping () -> Content) where Header == EmptyView, Footer == EmptyView {
        self.content = content
        self.header = { EmptyView() }
        self.footer = { EmptyView() }
    }

    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header) where Footer == EmptyView {
        self.content = content
        self.header = header
        self.footer = { EmptyView() }
    }

    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder footer: @escaping () -> Footer) where Header == EmptyView {
        self.content = content
        self.header = { EmptyView() }
        self.footer = footer
    }

    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header, @ViewBuilder footer: @escaping () -> Footer) {
        self.content = content
        self.header = header
        self.footer = footer
    }

    @ScaledMetric private var cornerRadius: CGFloat = 8
    @ScaledMetric private var spacing: CGFloat = 8
    @ScaledMetric private var padding: CGFloat = 24

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            header()
                .foregroundColor(Color.secondaryLabel)
                .font(Font.headline.weight(.regular).lowercaseSmallCaps().uppercaseSmallCaps())

            VStack { content() }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                    .foregroundColor(.secondarySystemGroupedBackground)
                )

            footer()
                .foregroundColor(Color.secondaryLabel)
                .font(Font.footnote)
        }
        .padding(.top, padding)
        .padding(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
    }
}
