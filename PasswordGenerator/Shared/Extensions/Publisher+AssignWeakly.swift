import Combine
import Foundation

extension Publisher where Failure == Never {

    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        onWeak object: Root
    ) -> AnyCancellable {

        sink { [weak object] value in

            object?[keyPath: keyPath] = value
        }
    }
}
