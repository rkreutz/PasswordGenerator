import UIKit

extension UIPasteboard: Pasteboard {

    func copy(string: String) {

        self.string = string
    }
}
