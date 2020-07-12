import SwiftUI

struct ErrorEmittingViewModifier: ViewModifier {

    @Environment(\.errorHandler) var handler

    var error: Binding<Error?>

    func body(content: Content) -> some View {

        handler.handle(
            error,
            in: content
        )
    }
}

extension View {

    func emittingError(_ error: Binding<Error?>) -> some View {

        modifier(ErrorEmittingViewModifier(error: error))
    }
}
