import Foundation
import struct SwiftUI.LocalizedStringKey

extension PasswordGeneratorView.ConfigurationView {

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

    struct State: Equatable {

        var passwordType: PasswordType
        var domainState: PasswordGeneratorView.DomainView.State
        var serviceState: PasswordGeneratorView.ServiceView.State
        var isValid: Bool
    }
}
