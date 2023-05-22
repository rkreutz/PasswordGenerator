import ComposableArchitecture
import Foundation
import PasswordGeneratorKit

extension PasswordGenerator {
    struct PasswordEntropy: Reducer {
        struct State: Equatable {
            var passwordEntropy: Double
            var entropyGeneratorSize: UInt

            var actualEntropy: Double { max(min(passwordEntropy, Double(entropyGeneratorSize * 8)), 0) }
            var isEntropyGeneratorOverflowed: Bool { passwordEntropy > Double(entropyGeneratorSize * 8) }
        }

        typealias Action = Never

        var body: some ReducerOf<Self> { EmptyReducer() }
    }
}
