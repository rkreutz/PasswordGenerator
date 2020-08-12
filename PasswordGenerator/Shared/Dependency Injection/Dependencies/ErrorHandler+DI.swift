import SwiftUI

enum ErrorHandlerEnvironmentKey: EnvironmentKey {

    static let defaultValue: ErrorHandler = DefaultErrorHandler()
}

extension EnvironmentValues {

    var errorHandler: ErrorHandler {

        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}

extension View {

    func handlingErrors(using handler: ErrorHandler) -> some View {

        environment(\.errorHandler, handler)
    }
}
