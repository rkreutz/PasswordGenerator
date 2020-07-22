import SwiftUI

extension PasswordGeneratorView {

    enum PasswordType: CaseIterable, Hashable {

        case domainBased
        case serviceBased

        var title: LocalizedStringKey {

            switch self {

            case .domainBased:
                return Strings.PasswordGeneratorView.domainBased

            case .serviceBased:
                return Strings.PasswordGeneratorView.serviceBased
            }
        }
    }
}
