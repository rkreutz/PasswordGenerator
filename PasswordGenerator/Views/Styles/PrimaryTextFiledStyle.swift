import SwiftUI

struct PrimaryTextFiledStyle: TextFieldStyle {

    //swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {

        configuration
            .foregroundColor(.foreground)
            .font(.system(.title, design: .monospaced))
    }
}
