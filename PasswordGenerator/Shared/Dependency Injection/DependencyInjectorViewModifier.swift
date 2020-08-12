import SwiftUI

struct DependencyInjectorViewModifier: ViewModifier {

    @Environment(\.appState) private var appState
    @Environment(\.calendar) private var calendar
    @Environment(\.locale) private var locale
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.masterPasswordStorage) private var masterPasswordStorage
    @Environment(\.masterPasswordValidator) private var masterPasswordValidator
    @Environment(\.passwordGenerator) private var passwordGenerator
    @Environment(\.timeZone) private var timeZone
    var environmentValues: EnvironmentValues {

        var environment = EnvironmentValues()
        environment.appState = appState
        environment.calendar = calendar
        environment.locale = locale
        environment.managedObjectContext = managedObjectContext
        environment.masterPasswordStorage = masterPasswordStorage
        environment.masterPasswordValidator = masterPasswordValidator
        environment.passwordGenerator = passwordGenerator
        environment.timeZone = timeZone
        return environment
    }

    var dependencyInjectable: DependencyInjectable

    func body(content: Content) -> some View {

        content.onAppear { self.dependencyInjectable.inject(self.environmentValues) }
    }
}

extension View {

    func injectEnvironment(into dependencyInjectable: DependencyInjectable) -> some View {

        modifier(DependencyInjectorViewModifier(dependencyInjectable: dependencyInjectable))
    }
}
