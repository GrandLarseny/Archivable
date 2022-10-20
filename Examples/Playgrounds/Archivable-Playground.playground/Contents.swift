import Foundation


/// This playground demonstrates simple archiving and retrieval of a structure
/// Since Swift playgrounds do not include any access to the Keychain, we cannot
/// demonstrate archiving a structure to the keychain.
///
///

struct User: Archivable {

    let name: String
    let age: Int
}

struct Profile: Archivable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    let image: Data
}

func printArchives() {
    print("user = \(User.retrieve()?.name ?? "<unable to retrieve>")")
    print("profile image length = \(Profile.retrieve()?.image.count ?? -1)")
}

func resetArchives() {
    User.removeArchive()
    Profile.removeArchive()
}

resetArchives()

if !User.hasArchive {
    let user = User(name: "Testy", age: 33)
    let profile = Profile(image: try! Data(contentsOf: URL(string: "https://daringfireball.net/graphics/author/addison-bw-425.jpg")!))

    do {
        try user.archive()
        try profile.archive()
    } catch {
        print(error)
    }
}

printArchives()
