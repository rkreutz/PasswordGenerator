import Foundation

extension PasswordGeneratorView {

    struct ConfigurationState: Equatable {

        var passwordType: PasswordType = .domainBased
        var username: String = ""
        var domain: String = ""
        var seed: Int = 1
        var service: String = ""

        var isValid: Bool {

            switch passwordType {

            case .domainBased:
                return username.isNotEmpty && domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)

            case .serviceBased:
                return service.isNotEmpty
            }
        }
    }
}
