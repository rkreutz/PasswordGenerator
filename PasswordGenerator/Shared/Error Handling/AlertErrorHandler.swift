import SwiftUI

struct AlertErrorHandler: ErrorHandler {

    func handle<Content: View>(_ error: Binding<Error?>, in view: Content) -> AnyView {

        let binding = Binding(
            get: { error.wrappedValue != nil },
            set: { isPresented, transaction in
                guard !isPresented else { return }
                error.transaction(transaction).wrappedValue = nil
            }
        )

        return view
            .alert(isPresented: binding) { () -> Alert in
                Alert(
                    title: Text(Strings.Error.title),
                    message: Text(error.wrappedValue?.localizedDescription ?? ""),
                    dismissButton: .default(Text(Strings.Generic.okay))
                )
            }
            .asAny()
    }
}
