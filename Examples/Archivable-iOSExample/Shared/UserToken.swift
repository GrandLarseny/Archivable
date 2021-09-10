//
//  UserToken.swift
//  Archivable-ExampleModels
//
//  Created by Daniel Larsen on 8/31/21.
//

import Archivable

struct UserToken: Archivable {

    static var location: ArchiveLocation { .keychain }

    let token: String
}
