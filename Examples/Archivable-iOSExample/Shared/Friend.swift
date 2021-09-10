//
//  User.swift
//  Archivable-ExampleModels
//
//  Created by Daniel Larsen on 8/31/21.
//

import Archivable
import Foundation

struct Friend: Archivable {

    let name: String
    let age: Int
    let token: UserToken?
}
