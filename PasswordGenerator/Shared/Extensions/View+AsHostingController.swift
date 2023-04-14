import SwiftUI

extension View {

    func asHostingController() -> UIHostingController<Self> {

        UIHostingController(rootView: self)
    }
}
