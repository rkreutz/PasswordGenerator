import Foundation

extension PasswordGeneratorView {

    enum PasswordState: Equatable {

        case invalid
        case readyToGenerate
        case loading
        case generated(String)
    }
}
