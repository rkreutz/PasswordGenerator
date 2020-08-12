import SwiftUI

protocol DependencyInjectable: AnyObject {

    var environment: EnvironmentValues { get set }

    func inject(_ environmentValues: EnvironmentValues)
}

extension DependencyInjectable {

    func inject(_ environmentValues: EnvironmentValues) {

        self.environment = environmentValues
    }
}
