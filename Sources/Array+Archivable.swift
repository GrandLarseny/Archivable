//
//  File.swift
//  
//
//  Created by Daniel Larsen on 9/8/21.
//

import Foundation

extension Array: Archivable where Element: Archivable {

    public static var location: ArchiveLocation { Element.location }

    public var archiveKey: String {
        return "archive.Array.\(type(of: Element.self))"
    }
}
