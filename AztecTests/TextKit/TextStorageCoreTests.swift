import Foundation
import XCTest
@testable import Aztec

class TextStorageCoreTests: XCTestCase {

    /// Test Storage
    ///
    var storage: TextStorageCore!
    var htmlConverter: HTMLConverter!

    override func setUp() {
        super.setUp()

        storage = TextStorageCore()
        htmlConverter = HTMLConverter()
    }

    // MARK: - Test string replacements

    func testReplaceWithSimpleString() {
        let str = NSAttributedString(string: "Hello, World")
        let expectedStr = "Hello, Space"
        storage.setString(str)
        storage.replaceCharacters(in: NSRange(location: 7, length: 5), with: "Space")
        let outputStr = storage.string
        XCTAssertEqual(expectedStr, outputStr)
    }

    func testReplaceWithHtmlString() {
        let html = "<p><b>Hello, World</b></p>"
        let expectedStr = "Hello, Space"
        storage.setString(htmlConverter.attributedString(from:html))
        storage.replaceCharacters(in: NSRange(location: 7, length: 5), with: "Space")
        let outputStr = storage.string
        XCTAssertEqual(expectedStr, outputStr)
    }
}
