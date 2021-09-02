//
//  FileManager+Extensions.swift
//  theskimm
//
//  Created by Daniel Larsen on 3/24/21.
//  Copyright © 2021 theSkimm. All rights reserved.
//

import Foundation

enum ArchiveFilePath {
    case documentsDirectory
    case cachesDirectory
    case applicationSupportDirectory
    case sharedContainerURL(securityApplicationGroupIdentifier: String)
    case custom(path: URL)

    private var searchDirectory: FileManager.SearchPathDirectory? {
        switch self {
        case .documentsDirectory: return .documentDirectory
        case .cachesDirectory: return .cachesDirectory
        case .applicationSupportDirectory: return .applicationSupportDirectory
        default: return nil
        }
    }

    var url: URL {
        let manager = FileManager.default

        switch self {
        case .documentsDirectory, .cachesDirectory, .applicationSupportDirectory:
            guard let searchDirectory = searchDirectory,
                  let folder = manager.urls(for: searchDirectory, in: .userDomainMask).first else {
                fatalError("Could not locate \(self).")
            }

            return folder
        case .sharedContainerURL(let groupIdentifier):
            guard let sharedContainerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
                fatalError("Could not locate Shared Container URL.")
            }

            return sharedContainerURL
        case .custom(let path):
            return path
        }
    }
}
