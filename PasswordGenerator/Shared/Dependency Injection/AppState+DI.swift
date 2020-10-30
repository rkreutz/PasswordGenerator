import SwiftUI

enum AppStateEnvironmentKey: EnvironmentKey {

    static let defaultValue = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)
}

extension EnvironmentValues {

    var appState: AppState {

        get { self[AppStateEnvironmentKey.self] }
        set { self[AppStateEnvironmentKey.self] = newValue }
    }
}

extension View {

    func use(appState: AppState) -> some View {

        environment(\.appState, appState)
    }
}
