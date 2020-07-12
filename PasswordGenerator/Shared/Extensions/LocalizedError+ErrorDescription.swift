import Foundation

extension LocalizedError {

    public var errorDescription: String? {

        let mirror = Mirror(reflecting: self)

        switch mirror.children.first {

        case .none:
            return NSLocalizedString(
                "\(String(reflecting: type(of: self))).\(String(describing: self))",
                tableName: "Errors",
                comment: "Error \(self)"
            )

        case let .some((.some(label), value as CustomStringConvertible)):
            return String(
                format: NSLocalizedString(
                    "\(String(reflecting: type(of: self))).\(label)",
                    tableName: "Errors",
                    comment: "Error \(self)"
                ),
                value.description
            )

        case let .some((.some(label), value as Error)):
            return String(
                format: NSLocalizedString(
                    "\(String(reflecting: type(of: self))).\(label)",
                    tableName: "Errors",
                    comment: "Error \(self)"
                ),
                value.localizedDescription
        )

        case let .some((.some(label), _)):
            return NSLocalizedString(
                "\(String(reflecting: type(of: self))).\(label)",
                tableName: "Errors",
                comment: "Error \(self)"
            )

        default:
            return nil
        }
    }
}
