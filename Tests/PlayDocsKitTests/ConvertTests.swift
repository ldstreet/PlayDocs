import XCTest
import class Foundation.Bundle
@testable import PlayDocsKit

final class ConvertTests: XCTestCase {
    func testConvert_SingleLineOfCode() throws {
        let source = """
        func helloWorld() {}
        """
        
        let expectedConvertedText = """
        FUNC HELLOWORLD() {}
        """
        
        let convertedText = convert(from: source) { chunk in
            return chunk.text.uppercased()
        }
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvert_MultipleLinesOfCode() throws {
        let source = """
        func helloWorld() {
            print("Hello, World!")
        }
        """
        
        let expectedConvertedText = """
        FUNC HELLOWORLD() {
            PRINT("HELLO, WORLD!")
        }
        """
        
        let convertedText = convert(from: source) { chunk in
            return chunk.text.uppercased()
        }
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvert_SingleLineOfMarkdown() throws {
        let source = """
        //: ## Hello World ##
        """
        
        let expectedConvertedText = """
         ## HELLO WORLD ##
        """
        
        let convertedText = convert(from: source) { chunk in
            return chunk.text.uppercased()
        }
        
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
        ## HELLO, WORLD ##
        IT'S A-ME, A-MARIO!
        """
        
        let convertedText = convert(from: source) { chunk in
            return chunk.text.uppercased()
        }
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvert_MultipleLinesOfMarkdownAndCode() throws {
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
        ## HELLO, WORLD ##
        IT'S A-ME, A-MARIO!

        FUNC HELLOWORLD() {
            PRINT("HELLO, WORLD!")
        }
        """
        
        let convertedText = convert(from: source) { chunk in
            return chunk.text.uppercased()
        }
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }

    static var allTests = [
        ("testConvert_SingleLineOfCode", testConvert_SingleLineOfCode),
        ("testConvert_MultipleLinesOfCode", testConvert_MultipleLinesOfCode),
        ("testConvert_SingleLineOfMarkdown", testConvert_SingleLineOfMarkdown),
        ("testConvert_MultipleLinesOfMarkdown", testConvert_MultipleLinesOfMarkdown)
    ]
}
