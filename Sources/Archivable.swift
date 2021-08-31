//
//  Archivable.swift
//  theskimm
//
//  Created by Daniel Larsen on 3/24/21.
//  Copyright © 2021 theSkimm. All rights reserved.
//

public enum ArchiveLocation {

    case filesystem(folderPath: URL = FileManager.default.documentsDirectory)
    case keychain
    case userDefaults
}

public protocol Archivable: Codable {

    static var location: ArchiveLocation { get }

    var archiveKey: String { get }
}

// MARK: - Default implementation

public extension Archivable {

    static var location: ArchiveLocation { .userDefaults }

    // MARK: Default functions

    static var archiveKey: String {
        return "archive.\(type(of: Self.self))"
    }

    static func encode(_ archivable: Self) throws -> Data {
        return try JSONEncoder().encode(archivable)
    }

    static func decode(data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }

    func encode() throws -> Data {
        return try Self.encode(self)
    }

    var archiveKey: String {
        return Self.archiveKey
    }

    func archive(key: String = archiveKey) throws {
        try Self.archive(self, archiveKey: key)
    }

    func removeArchive(key: String = archiveKey) throws {
        try Self.archive(nil, archiveKey: key)
    }
}

// MARK: - Default static functions

public extension Archivable {

    static var hasArchive: Bool {
        return UserDefaults.standard.bool(forKey: "\(archiveKey).hasArchive")
    }

    static func archive(_ archivable: Self?, archiveKey: String) throws {
        let data = try archivable?.encode()
        switch location {
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: archiveKey)
        case .filesystem(let path):
            FileManager.default.createFile(atPath: path.appendingPathComponent(archiveKey).absoluteString, contents: data)
        case .keychain:
            if let data = data {
                try keychainSave(data: data, to: archiveKey)
            } else {
                try keychainDelete(key: archiveKey)
            }
        }

        UserDefaults.standard.set((data != nil), forKey: "\(archiveKey).hasArchive")
    }

    static func retrieve(key: String = archiveKey) -> Self? {
        switch location {
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return try? decode(data: data)
        case .filesystem(let path):
            guard let data = FileManager.default.contents(atPath: path.appendingPathComponent(archiveKey).absoluteString) else { return nil }
            return try? decode(data: data)
        case .keychain:
            guard let data = try? keychainRead(key: archiveKey) else { return nil }
            return try? decode(data: data)
        }
    }

    static func removeArchive(key: String = archiveKey) {
        UserDefaults.standard.removeObject(forKey: "\(archiveKey).hasArchive")

        switch location {
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: archiveKey)
        case .filesystem(let path):
            try? FileManager.default.removeItem(at: path.appendingPathComponent(archiveKey))
        case .keychain:
            try? keychainDelete(key: archiveKey)
        }
    }
}