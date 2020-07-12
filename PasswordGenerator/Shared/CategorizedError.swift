import Foundation

protocol CategorizedError: Error {

    var category: Error.Category { get }
}

enum ErrorCategory: Equatable {

    case alert
    case toast
}

extension Error {

    typealias Category = ErrorCategory

    func resolveCategory() -> Category {

        guard let categorized = self as? CategorizedError else { return .toast }
        return categorized.category
    }
}
