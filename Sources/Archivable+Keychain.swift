//
//  Archivable+Keychain.swift
//  Archivable
//
//  Created by Daniel Larsen on 3/24/21.
//  Copyright © 2021 BottleRocket. All rights reserved.
//

import Foundation

enum KeychainError: Error {

    case noCredentials
    case unexpectedCredentialData
    case unexpectedItemData
    case unhandledError(status: OSStatus)
}

extension Archivable {

    private static var service: String { Bundle.main.bundleIdentifier ?? "Application" }

    // MARK: Keychain access

    static func keychainRead(key: String) throws -> Data {
        var query = keychainQuery(withService: service, key: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard status != errSecItemNotFound else { throw KeychainError.noCredentials }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = queryResult as? [String: AnyObject],
            let credentialData = existingItem[kSecValueData as String] as? Data
        else {
            throw KeychainError.unexpectedCredentialData
        }

        return credentialData
    }

    static func keychainSave(data: Data, to key: String) throws {

        do {
            try _ = keychainRead(key: key)

            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = data as AnyObject?

            let query = keychainQuery(withService: service, key: key)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.noCredentials {
            var newItem = keychainQuery(withService: service, key: key)
            newItem[kSecValueData as String] = data as AnyObject?
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

            let status = SecItemAdd(newItem as CFDictionary, nil)

            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }

    static func keychainDelete(key: String) throws {
        let query = keychainQuery(withService: service, key: key)
        let status = SecItemDelete(query as CFDictionary)

        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }

    // MARK: Convenience

    private static func keychainQuery(withService service: String, key: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let key = key {
            query[kSecAttrGeneric as String] = key as AnyObject?
        }

        return query
    }
}
