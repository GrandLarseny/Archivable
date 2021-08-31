import XCTest
@testable import Archivable

final class ArchivableTests: XCTestCase {

    private struct User: Archivable {

        let name: String
        let age: Int

        static let testUser = User(name: "Testy", age: 33)
    }

    override class func setUp() {
        super.setUp()

        try! User.testUser.archive()
    }

    func testExample() {
        let user = User.retrieve()

        XCTAssertEqual(user?.name, "Testy")
    }
}
