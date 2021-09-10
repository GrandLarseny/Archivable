//
//  ArchiveFilePath.swift
//  Archivable
//
//  Created by Daniel Larsen on 3/24/21.
//  Copyright © 2021 BottleRocket. All rights reserved.
//

import Foundation

public enum ArchiveFilePath {
    
    case documents
    case caches
    case applicationSupport
    case sharedContainerURL(securityApplicationGroupIdentifier: String)
    case custom(path: URL)

    var url: URL {
        let manager = FileManager.default

        switch self {
        case .documents, .caches, .applicationSupport:
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

    var path: String {
        return url.path
    }
}

private extension ArchiveFilePath {
    
    var searchDirectory: FileManager.SearchPathDirectory? {
        switch self {
        case .documents: return .documentDirectory
        case .caches: return .cachesDirectory
        case .applicationSupport: return .applicationSupportDirectory
        default: return nil
        }
    }
}
