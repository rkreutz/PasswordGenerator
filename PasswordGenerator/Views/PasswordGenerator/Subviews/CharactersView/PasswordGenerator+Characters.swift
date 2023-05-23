import ComposableArchitecture
import Foundation
import PasswordGeneratorKit

extension PasswordGenerator {
    struct Characters: Reducer {
        struct State: Equatable {
            var digits: CounterToggle.State
            var symbols: CounterToggle.State
            var lowercase: CounterToggle.State
            var uppercase: CounterToggle.State
            var shouldUseOptimisedUI: Bool

            var isValid: Bool {
                digits.isToggled || symbols.isToggled || lowercase.isToggled || uppercase.isToggled
            }

            var totalCharacters: Int {
                digits.counter.count + symbols.counter.count + lowercase.counter.count + uppercase.counter.count
            }

            var charactersPoolSize: Int {
                var poolSize = 0
                if digits.isToggled {
                    poolSize += PasswordRule.CharacterSet.decimal.count
                }
                if symbols.isToggled {
                    poolSize += PasswordRule.CharacterSet.symbol.count
                }
                if lowercase.isToggled {
                    poolSize += PasswordRule.CharacterSet.lowercase.count
                }
                if uppercase.isToggled {
                    poolSize += PasswordRule.CharacterSet.uppercase.count
                }
                return poolSize
            }
        }

        enum Action {
            case digits(CounterToggle.Action)
            case symbols(CounterToggle.Action)
            case lowercase(CounterToggle.Action)
            case uppercase(CounterToggle.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.digits, action: /Action.digits) { CounterToggle() }
            Scope(state: \.symbols, action: /Action.symbols) { CounterToggle() }
            Scope(state: \.lowercase, action: /Action.lowercase) { CounterToggle() }
            Scope(state: \.uppercase, action: /Action.uppercase) { CounterToggle() }
        }
    }
}
