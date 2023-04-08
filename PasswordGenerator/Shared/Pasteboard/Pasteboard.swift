import Dependencies
import UIKit

protocol Pasteboard {
    func copy(string: String)
}

private enum PasteboardKey: DependencyKey {
    static let liveValue: Pasteboard = UIPasteboard.general
}

extension DependencyValues {
    var pasteboard: Pasteboard {
        get { self[PasteboardKey.self] }
        set { self[PasteboardKey.self] = newValue }
    }
}
