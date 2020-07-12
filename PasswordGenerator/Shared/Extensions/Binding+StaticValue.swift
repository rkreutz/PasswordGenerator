import SwiftUI

extension Binding {

    init(_ value: Value) {

        self.init(get: { value }, set: { _ in })
    }
}

extension Binding: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {

    public init(booleanLiteral value: Value.BooleanLiteralType) {

        self.init(Value(booleanLiteral: value))
    }
}

extension Binding: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Value.IntegerLiteralType) {

        self.init(Value(integerLiteral: value))
    }
}

extension Binding: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Value.FloatLiteralType) {

        self.init(Value(floatLiteral: value))
    }
}

extension Binding: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {

    public init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {

        self.init(Value(unicodeScalarLiteral: value))
    }
}

extension Binding: ExpressibleByExtendedGraphemeClusterLiteral
where Value: ExpressibleByExtendedGraphemeClusterLiteral {

    public init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {

        self.init(Value(extendedGraphemeClusterLiteral: value))
    }
}

extension Binding: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {

    public init(stringLiteral value: Value.StringLiteralType) {

        self.init(Value(stringLiteral: value))
    }
}
