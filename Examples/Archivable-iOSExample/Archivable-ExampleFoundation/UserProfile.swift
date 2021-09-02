//
//  UserProfile.swift
//  Archivable-ExampleModels
//
//  Created by Daniel Larsen on 8/31/21.
//

import Archivable
import SwiftUI

struct UserProfile: Archivable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    let profileImageData: Data
    
    var profileImage: Image? {
        guard let uiImage = UIImage(data: profileImageData) else { return nil }
        return Image(uiImage: uiImage)
    }
}
