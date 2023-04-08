import Foundation

final class MasterPasswordKeychain {

    static let shared = MasterPasswordKeychain()

    private init() {
        migrateKeychain()
    }
}
