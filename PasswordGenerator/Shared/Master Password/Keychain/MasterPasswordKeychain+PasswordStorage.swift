import Foundation
import LocalAuthentication

extension MasterPasswordKeychain: MasterPasswordStorage {

    var protectedAccess: SecAccessControl? {

        SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .userPresence,
            nil
        )
    }

    var freeAccess: SecAccessControl? {

        SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            [],
            nil
        )
    }
    
    private var context: LAContext {

        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 30
        context.localizedReason = Strings.MasterPasswordKeychain.prompt
        return context
    }

    //swiftlint:disable:next function_body_length
    func save(masterPassword: String) throws {

        guard let passwordData = masterPassword.data(using: .utf8) else { throw Error.invalidPassword }

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {

            throw Error.deviceLacksAuthentication
        }

        if hasMasterPassword {

            let query: [CFString: Any?] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: Constants.service,
                kSecAttrAccount: Constants.passwordKey
            ]

            let attributesToUpdate: [CFString: Any?] = [
                kSecValueData: passwordData
            ]

            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == errSecSuccess else {

                switch status {

                case errSecUserCanceled:
                    throw Error.canceled

                default:
                    throw Error.keychainError(status)
                }
            }
        } else {

            let protectedQuery: [CFString: Any?] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: Constants.service,
                kSecAttrAccount: Constants.passwordKey,
                kSecAttrAccessControl: protectedAccess,
                kSecUseAuthenticationContext: context,
                kSecValueData: passwordData
            ]

            let protectedStatus = SecItemAdd(protectedQuery as CFDictionary, nil)
            guard protectedStatus == errSecSuccess else {

                switch protectedStatus {

                case errSecUserCanceled:
                    throw Error.canceled

                default:
                    throw Error.keychainError(protectedStatus)
                }
            }

            let unprotectedQuery: [CFString: Any?] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: Constants.service,
                kSecAttrAccount: Constants.hasPasswordKey,
                kSecAttrAccessControl: freeAccess
            ]

            let unprotectedStatus = SecItemAdd(unprotectedQuery as CFDictionary, nil)
            guard unprotectedStatus == errSecSuccess else {

                try? deleteMasterPassword()
                throw Error.keychainError(unprotectedStatus)
            }
        }
    }

    func masterPassword() throws -> String {

        let query: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrService: Constants.service,
            kSecAttrAccount: Constants.passwordKey,
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData: kCFBooleanTrue
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else {

            switch status {

            case errSecUserCanceled:
                throw Error.canceled

            case errSecItemNotFound:
                throw Error.noPassword

            default:
                throw Error.keychainError(status)
            }
        }

        guard
            let existingItem = item as? [CFString: Any?],
            let passwordData = existingItem[kSecValueData] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else { throw Error.noPassword }

        return password
    }

    func deleteMasterPassword() throws {

        let query: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Constants.service
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw Error.keychainError(status) }
    }
}
