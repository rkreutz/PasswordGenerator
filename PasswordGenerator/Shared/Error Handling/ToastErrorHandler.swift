import SwiftUI

struct ToastErrorHandler: ErrorHandler {

    func handle<Content: View>(_ error: Binding<Error?>, in view: Content) -> AnyView {

        let binding = Binding(
            get: { error.wrappedValue?.localizedDescription },
            set: { text, transaction in
                guard text == nil else { return }
                error.transaction(transaction).wrappedValue = nil
            }
        )

        return view
            .toast(text: binding)
            .asAny()
    }
}
