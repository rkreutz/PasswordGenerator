import Dependencies
import SwiftUI

typealias Sleep = (SleepDuration) async throws -> Void

enum SleepDuration {
    case seconds(UInt64)
    case milliseconds(UInt64)
    case microseconds(UInt64)
    case nanoseconds(UInt64)
}

private enum SleepKey: DependencyKey {
    static let liveValue: Sleep = { duration in
        switch duration {
        case .seconds(let value):
            try await Task.sleep(nanoseconds: value * NSEC_PER_SEC)
        case .milliseconds(let value):
            try await Task.sleep(nanoseconds: value * NSEC_PER_MSEC)
        case .microseconds(let value):
            try await Task.sleep(nanoseconds: value * NSEC_PER_USEC)
        case .nanoseconds(let value):
            try await Task.sleep(nanoseconds: value)
        }
    }
}

extension DependencyValues {
    var sleep: Sleep {
        get { self[SleepKey.self] }
        set { self[SleepKey.self] = newValue }
    }
}
