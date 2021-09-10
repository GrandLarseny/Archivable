import Foundation

struct User: Archivable {

    let name: String
    let age: Int
}

struct Profile: Archivable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    let image: Data
}

struct Authentication: Archivable {

    static var location: ArchiveLocation { .keychain }

    let token: String
}

if !User.hasArchive {
    let user = User(name: "Testy", age: 33)
    let profile = Profile(image: try! Data(contentsOf: URL(string: "https://emojis.slackmojis.com/emojis/images/1535143994/4548/dealwhithit.gif?1535143994")!))
    let _ = Authentication(token: UUID().uuidString)

    do {
        try user.archive()
        try profile.archive()
//        try auth.archive() // This doesn't work in playgrounds for now
    } catch {
        print(error)
    }
}

func printArchives() {
    print("user = \(User.retrieve()?.name ?? "<unable to retrieve>")")
    print("profile = \(Profile.retrieve().debugDescription)")
    print("auth = \(Authentication.retrieve()?.token ?? "<unable to retrieve>")")
}

printArchives()
