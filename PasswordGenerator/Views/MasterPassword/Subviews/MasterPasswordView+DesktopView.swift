import SwiftUI

extension MasterPasswordView {
    struct DesktopView: View {

        private enum Constants {
            static let helpIconName = "questionmark.circle.fill"
        }

        let isValid: Bool
        @Binding var masterPassword: String
        let saveAction: () -> Void

        @ScaledMetric private var minWidth: CGFloat = 300
        @ScaledMetric private var maxWidth: CGFloat = 800

        var body: some View {
            HStack {
                TextField(
                    Strings.MasterPasswordView.placeholder,
                    text: $masterPassword
                )
                .help(Strings.MasterPasswordView.title)
                .disableAutocorrection(true)
                .textFieldStyle(PrimaryTextFieldStyle())

                Button(
                    action: saveAction,
                    label: { Text(Strings.MasterPasswordView.save) }
                )
                .font(.title3)
                .keyboardShortcut(.defaultAction)
                .disabled(!isValid)

                Image(systemName: Constants.helpIconName)
                    .foregroundColor(.secondaryLabel)
                    .font(.title3)
                    .help(Strings.MasterPasswordView.title)
            }
            .frame(minWidth: minWidth, maxWidth: maxWidth)
            .padding()
        }
    }
}
