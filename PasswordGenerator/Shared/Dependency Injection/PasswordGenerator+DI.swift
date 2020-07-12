import SwiftUI
import PasswordGeneratorKit

enum PasswordGeneratorEnvironmentKey: EnvironmentKey {

    static var defaultValue: PasswordGenerator = PasswordGenerator(
        masterPasswordProvider: MasterPasswordKeychain(),
        iterations: 1_000,
        bytes: 8
    )
}

extension EnvironmentValues {

    var passwordGenerator: PasswordGenerator {

        get { self[PasswordGeneratorEnvironmentKey.self] }
        set { self[PasswordGeneratorEnvironmentKey.self] = newValue }
    }
}

extension View {

    func use(passwordGenerator: PasswordGenerator) -> some View {

        environment(\.passwordGenerator, passwordGenerator)
    }
}
