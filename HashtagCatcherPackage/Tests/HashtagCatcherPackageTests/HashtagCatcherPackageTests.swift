import XCTest
import Models
import RealmSwift

final class HashtagCatcherPackageTests: XCTestCase {
    func testCopyKeepsIdentityAndDoesNotMutateOriginal() throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let original = HashTagGroupDoc(name: "Travel", tags: "#旅行 #travel", createdAt: date)
        let copy = try XCTUnwrap(original.copy() as? HashTagGroupDoc)
        XCTAssertFalse(copy === original)
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.name, original.name)
        XCTAssertEqual(copy.tags, original.tags)
        XCTAssertEqual(copy.createdAt, date)
        XCTAssertEqual(copy.updatedAt, date)
        copy.name = "Edited"
        XCTAssertEqual(original.name, "Travel")
    }

    func testRealmRoundTripAndUpdateByPrimaryKey() throws {
        let realm = try Realm(configuration: .init(inMemoryIdentifier: UUID().uuidString))
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let original = HashTagGroupDoc(name: "Travel", tags: "#旅行 #travel", createdAt: date)
        try realm.write { realm.add(original) }
        let saved = try XCTUnwrap(realm.object(ofType: HashTagGroupDoc.self, forPrimaryKey: original.id))
        XCTAssertEqual(saved.tags, "#旅行 #travel")
        XCTAssertEqual(saved.createdAt, date)
        let edited = try XCTUnwrap(saved.copy() as? HashTagGroupDoc)
        edited.tags = "#updated"
        try realm.write { realm.add(edited, update: .all) }
        XCTAssertEqual(realm.objects(HashTagGroupDoc.self).count, 1)
        XCTAssertEqual(saved.tags, "#updated")
        try realm.write { realm.delete(saved) }
        XCTAssertTrue(realm.objects(HashTagGroupDoc.self).isEmpty)
    }
}
