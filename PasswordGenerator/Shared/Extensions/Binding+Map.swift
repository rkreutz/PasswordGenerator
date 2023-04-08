import SwiftUI

extension Binding {
    func map<Mapped>(to: @escaping (Value) -> Mapped, from: @escaping (Mapped) -> Value?) -> Binding<Mapped> {
        .init(
            get: { to(self.wrappedValue) },
            set: { mapped, transaction in
                guard let value = from(mapped) else { return }
                self.transaction(transaction).wrappedValue = value
            }
        )
    }
}
