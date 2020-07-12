import SwiftUI
import Combine

extension MasterPasswordView {

    final class ViewModel: ObservableObject {

        @Environment(\.masterPasswordStorage) private var masterPasswordStorage

        @Published var masterPassword: String = ""
        @Published var error: Error?

        var isValid: Bool {

            get { masterPassword.isNotEmpty }
            set {  } //swiftlint:disable:this unused_setter_value
        }

        func saveMasterPassword(_ appState: AppState) {

            do {

                try masterPasswordStorage.save(masterPassword: masterPassword)
                appState.updateRoot = ()
            } catch {

                self.error = error
            }
        }
    }
}
