import SwiftUI

enum MasterPasswordStoragerEnvironmentKey: EnvironmentKey {

    static var defaultValue: MasterPasswordStorage = MasterPasswordKeychain()
}

extension EnvironmentValues {

    var masterPasswordStorage: MasterPasswordStorage {

        get { self[MasterPasswordStoragerEnvironmentKey.self] }
        set { self[MasterPasswordStoragerEnvironmentKey.self] = newValue }
    }
}

extension View {

    func use(masterPasswordStorage: MasterPasswordStorage) -> some View {

        environment(\.masterPasswordStorage, masterPasswordStorage)
    }
}
