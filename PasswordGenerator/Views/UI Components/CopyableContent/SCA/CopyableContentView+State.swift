import Foundation

extension CopyableContentView {

    struct State: Equatable {

        let content: String
        var hasCopied: Bool = false
    }
}
