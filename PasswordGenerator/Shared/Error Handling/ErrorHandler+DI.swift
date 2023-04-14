import SwiftUI

enum ErrorHandlerEnvironmentKey: EnvironmentKey {

    #if os(iOS)
    static let defaultValue: ErrorHandler = ToastErrorHandler()
    #elseif os(macOS)
    static let defaultValue: ErrorHandler = AlertErrorHandler()
    #endif
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
