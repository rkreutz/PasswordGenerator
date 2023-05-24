import SwiftUI

struct PasswordText: View {

    let password: String

    init(_ password: String) {
        self.password = password
    }

    var body: some View {
        if #available(iOS 15, macOS 12, *) {
            Text(AttributedString(fromPassword: password))
        } else {
            Text(password)
        }
    }
}

@available(iOS 15, macOS 12, *)
private extension AttributedString {
    init(fromPassword password: String) {
        let attributedString = NSMutableAttributedString()
        for character in password {
            switch character {
            case "a" ... "z":
                #if os(iOS)
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: UIColor.label]))
                #else
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: NSColor.labelColor]))
                #endif
            case "A" ... "Z":
                #if os(iOS)
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: UIColor.label.withAlphaComponent(0.65)]))
                #else
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: NSColor.labelColor.withAlphaComponent(0.65)]))
                #endif
            case "0" ... "9":
                #if os(iOS)
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: UIColor.systemOrange]))
                #else
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: NSColor.systemOrange]))
                #endif
            case "!", "@", "#", "$", "%", "&", "_", "-", "|", "?", ".":
                #if os(iOS)
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: UIColor.systemTeal]))
                #else
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: NSColor.systemTeal]))
                #endif
            default:
                #if os(iOS)
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: UIColor.label]))
                #else
                attributedString.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: NSColor.labelColor]))
                #endif
            }
        }
        self.init(attributedString)
    }
}
