import SwiftUI

extension Label where Title == Text, Icon == EmptyView {

    init(_ titleKey: LocalizedStringKey) {

        self.init(title: { Text(titleKey) }, icon: { EmptyView() })
    }
}
