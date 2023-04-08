import ComposableArchitecture
import Foundation

extension PasswordGenerator {
    struct Length: Reducer {
        typealias State = Counter.State
        typealias Action = Counter.Action

        var body: some ReducerOf<Self> {
            Counter()
        }
    }
}
