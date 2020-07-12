import Foundation

extension MasterPasswordKeychain {

    enum Error: LocalizedError {

        case keychainError(OSStatus)
        case canceled
        case noPassword
        case invalidPassword
        case deviceLacksAuthentication
    }
}
