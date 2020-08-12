import SwiftUI
import Combine

extension MasterPasswordView {

    final class ViewModel: ObservableObject, DependencyInjectable {

        var environment: EnvironmentValues = .init()

        @Published var masterPassword: String = ""
        @Published var error: Error?

        var isValid: Bool {

            get { masterPassword.isNotEmpty }
            set {  } //swiftlint:disable:this unused_setter_value
        }

        func saveMasterPassword() {

            do {

                try environment.masterPasswordStorage.save(masterPassword: masterPassword)
                environment.appState.state = .masterPasswordSet
            } catch {

                self.error = error
            }
        }
    }
}
