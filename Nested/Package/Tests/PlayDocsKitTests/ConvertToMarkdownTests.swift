import XCTest
import class Foundation.Bundle
@testable import PlayDocsKit



final class ConvertToMarkdownTests: XCTestCase {
    
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
    
    func testConvert_SingleLineOfMarkdown() throws {
        let source = """
        //: ## Hello World ##
        """
        
        let expectedConvertedText = """
         ## Hello World ##
        """
        
        let convertedText = convertToMarkdown(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvert_MultipleLinesOfMarkdown() throws {
        let source = """
        /*:
        ## Hello, World ##
        It's a-me, a-Mario!
        */
        """
        
        let expectedConvertedText = """
        ## Hello, World ##
        It's a-me, a-Mario!
        """
        
        let convertedText = convertToMarkdown(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToMarkdown_MultipleLinesOfMarkdownAndCode() throws {
        let source = """
        /*:
        ## Hello, World ##
        It's a-me, a-Mario!
        */

        func helloWorld() {
            print("Hello, World!")
        }
        """
        
        let expectedConvertedText = """
        ## Hello, World ##
        It's a-me, a-Mario!
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
        ("testConvertToMarkdown_MultipleLinesOfCode", testConvertToMarkdown_MultipleLinesOfCode),
        ("testConvert_SingleLineOfMarkdown", testConvert_SingleLineOfMarkdown),
        ("testConvert_MultipleLinesOfMarkdown", testConvert_MultipleLinesOfMarkdown),
    ]
}
