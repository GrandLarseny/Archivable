//
//  UserService.swift
//  Archivable-ExampleModels
//
//  Created by Daniel Larsen on 8/31/21.
//

import Foundation

class UserService {

    static var shared = UserService()

    func authenticate() -> UserToken {
        return UserToken(token: UUID().uuidString)
    }
}
