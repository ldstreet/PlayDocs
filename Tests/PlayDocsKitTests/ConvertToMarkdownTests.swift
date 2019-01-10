import XCTest
import class Foundation.Bundle
@testable import PlayDocsKit



final class ConvertToMarkdownTests: XCTestCase {
    
    override func setUp() {
        Current = World(convertToHTML: { (markdownSource) -> HTMLSource? in
            return "LINE OF HTML"
        }, convertToHighlightedHTML: { (swiftSource) -> HTMLSource in
            return "LINE OF SWIFT CODE"
        })
    }
    
    func testConvertToMarkdown_SingleLineOfCode() throws {
        let source = """
        func helloWorld() {}
        """
        
        let expectedConvertedText = """
        ```swift
        func helloWorld() {}
        ```
        """
        
        let convertedText = convertToMarkdown(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToMarkdown_MultipleLinesOfCode() throws {
        let source = """

        func helloWorld() {
            print("Hello, World!")

        }

        """
        
        let expectedConvertedText = """
        ```swift
        
        func helloWorld() {
            print("Hello, World!")

        }
        
        ```
        """
        
        let convertedText = convertToMarkdown(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    static var allTests = [
        ("testConvertToMarkdown_SingleLineOfCode", testConvertToMarkdown_SingleLineOfCode),
    ]
}
