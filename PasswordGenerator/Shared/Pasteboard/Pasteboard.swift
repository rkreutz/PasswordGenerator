import Dependencies
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

protocol Pasteboard {
    func copy(string: String)
}

private enum PasteboardKey: DependencyKey {
    #if os(iOS)
    static let liveValue: Pasteboard = UIPasteboard.general
    #elseif os(macOS)
    static let liveValue: Pasteboard = NSPasteboard.general
    #endif
}

extension DependencyValues {
    var pasteboard: Pasteboard {
        get { self[PasteboardKey.self] }
        set { self[PasteboardKey.self] = newValue }
    }
}
