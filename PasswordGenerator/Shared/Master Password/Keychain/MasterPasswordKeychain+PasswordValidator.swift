import Foundation

extension MasterPasswordKeychain: MasterPasswordValidator {

    var hasMasterPassword: Bool {

        let query: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrService: Constants.service,
            kSecAttrAccount: Constants.hasPasswordKey
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
