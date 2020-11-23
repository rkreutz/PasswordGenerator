import Foundation
import Combine

final class CancellableStore {

    fileprivate var cancellableSet: Set<AnyCancellable> = []

    func dispose() {

        cancellableSet = []
    }
}

extension AnyCancellable {

    func store(in store: CancellableStore) {

        store.cancellableSet.insert(self)
    }
}
