import SwiftUI

struct SecondaryTextFiledStyle: TextFieldStyle {

    //swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {

        configuration
            .foregroundColor(.foreground)
            .font(.body)
    }
}
