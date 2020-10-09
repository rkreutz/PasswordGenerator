import SwiftUI

struct PrimaryTextFiledStyle: TextFieldStyle {

    //swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {

        configuration
            .font(.system(.title, design: .monospaced))
            .foregroundColor(.foreground)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
