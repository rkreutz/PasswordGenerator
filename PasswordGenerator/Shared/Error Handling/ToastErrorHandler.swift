import SwiftUI

struct ToastErrorHandler: ErrorHandler {

    func handle<Content: View>(_ error: Binding<Error?>, in view: Content) -> AnyView {

        let binding = Binding(
            get: { error.wrappedValue?.localizedDescription },
            set: {

                guard $0 == nil else { return }
                error.wrappedValue = nil
            }
        )

        return view
            .toast(text: binding)
            .asAny()
    }
}
