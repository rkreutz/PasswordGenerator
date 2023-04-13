import SwiftUI

extension MasterPasswordView {
    struct CompactView: View {

        let isValid: Bool
        @Binding var masterPassword: String
        let saveAction: () -> Void

        @ScaledMetric private var spacing: CGFloat = 48
        @ScaledMetric private var margins: CGFloat = 16
        @ScaledMetric private var topMargin: CGFloat = 32

        var body: some View {
            ScrollView {
                VStack(spacing: spacing) {

                    TextField(
                        Strings.MasterPasswordView.placeholder,
                        text: $masterPassword
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(PrimaryTextFieldStyle())

                    Button(Strings.MasterPasswordView.save, action: saveAction)
                        .buttonStyle(MainButtonStyle())
                        .disabled(!isValid)

                    Label(Strings.MasterPasswordView.title)
                        .labelStyle(ParagraphStyle())
                }
                .padding(margins)
                .padding(.top, topMargin)
            }
        }
    }
}

#if DEBUG

struct MasterPasswordView_CompactView_Previews: PreviewProvider {

    static var previews: some View {
        MasterPasswordView.CompactView(
            isValid: false,
            masterPassword: .constant(""),
            saveAction: {}
        )
    }
}

#endif
