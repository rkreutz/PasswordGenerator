import SwiftUI

struct DefaultErrorHandler: ErrorHandler {

    func handle<Content: View>(_ error: Binding<Error?>, in view: Content) -> AnyView {

        let toastBinding = Binding(
            get: { error.wrappedValue?.localizedDescription },
            set: {

                guard $0 == nil else { return }
                error.wrappedValue = nil
            }
        )

        let alertBinding = Binding(
            get: { error.wrappedValue?.resolveCategory() == .alert },
            set: {

                guard !$0 else { return }
                error.wrappedValue = nil
            }
        )

        return view
            .alert(isPresented: alertBinding) { () -> Alert in

                Alert(
                    title: Text(Strings.Error.title),
                    message: Text(error.wrappedValue?.localizedDescription ?? ""),
                    dismissButton: .default(Text(Strings.Generic.okay))
                )
            }
            .toast(text: toastBinding)
            .asAny()
    }
}
