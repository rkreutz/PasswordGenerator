import SwiftUI

extension Scene {
    func defaultSizeIfApplicable(width: CGFloat, height: CGFloat) -> some Scene {
        if #available(macOS 13, *) {
            return self.defaultSize(width: width, height: height)
        } else {
            return self
        }
    }
}
