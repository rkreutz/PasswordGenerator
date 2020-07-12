import Foundation

public extension String {

    func hasMatchingTypes(_ types: NSTextCheckingTypes) -> Bool {

        let detector = try? NSDataDetector(types: types)
        let stringRange = NSRange(location: 0, length: self.utf8.count)
        guard let match = detector?.firstMatch(in: self, options: [], range: stringRange) else { return false }
        return match.range == stringRange
    }
}
