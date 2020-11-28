import Foundation

extension CopyableContentView {

    struct State: Equatable {

        var content: String
        var hasCopied: Bool = false
    }
}
