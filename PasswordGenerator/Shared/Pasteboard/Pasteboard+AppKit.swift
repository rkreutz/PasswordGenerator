import AppKit

extension NSPasteboard: Pasteboard {
    func copy(string: String) {
        self.clearContents()
        self.setString(string, forType: .string)
    }
}
