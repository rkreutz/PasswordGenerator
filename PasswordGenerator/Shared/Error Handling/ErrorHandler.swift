import SwiftUI

protocol ErrorHandler {

    func handle<Content: View>(_ error: Binding<Error?>, in view: Content) -> AnyView
}
