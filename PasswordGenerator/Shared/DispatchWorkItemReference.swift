import Foundation

final class DispatchWorkItemReference {

    var workItem: DispatchWorkItem? {

        didSet {

            oldValue?.cancel()
        }
    }
}
