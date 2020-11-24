import Foundation

extension CounterView {

    struct State: Equatable {

        let title: String
        var count: Int
        var bounds: ClosedRange<Int>
    }
}
