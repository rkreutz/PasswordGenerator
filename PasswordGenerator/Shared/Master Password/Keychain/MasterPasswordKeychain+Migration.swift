import Foundation

extension MasterPasswordKeychain {
    
    func migrateKeychain() {

        removeLeakedPasswordInHasPasswordKeyIfNeeded()
    }

    /// This will check if `has_password` keycahin account holds any data leaking the master password, if it does then we remove it.
    private func removeLeakedPasswordInHasPasswordKeyIfNeeded() {

        var item: CFTypeRef?
        let query: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrService: Constants.service,
            kSecAttrAccount: Constants.hasPasswordKey,
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData: kCFBooleanTrue
        ]

        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard
            status == errSecSuccess,
            let existingItem = item as? [CFString: Any?],
            let passwordData = existingItem[kSecValueData] as? Data,
            passwordData.isNotEmpty
        else { return }

        let deletionQuery: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Constants.service,
            kSecAttrAccount: Constants.hasPasswordKey,
        ]

        let deletionStatus = SecItemDelete(deletionQuery as CFDictionary)
        guard deletionStatus == errSecSuccess else { return }

        let insertionQuery: [CFString: Any?] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Constants.service,
            kSecAttrAccount: Constants.hasPasswordKey,
            kSecAttrAccessControl: freeAccess
        ]

        SecItemAdd(insertionQuery as CFDictionary, nil)
    }
}
