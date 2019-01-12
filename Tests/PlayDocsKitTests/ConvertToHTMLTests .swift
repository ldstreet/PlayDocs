import XCTest
import class Foundation.Bundle
@testable import PlayDocsKit



final class ConvertToHTMLTests: XCTestCase {

    
    func testConvertToHTML_SingleLineOfCode() throws {
        let source = """
        func helloWorld() {}
        """
        
        let expectedConvertedText = """
        <style type="text/css" media="screen">
        pre {
            margin-bottom: 1.5em;
            background-color: #1a1a1a;
            padding: 16px 0;
            border-radius: 16px;
            word-wrap: normal;
        }

        pre code {
            font-family: monospace;
            display: block;
            padding: 0 20px;
            color: #a9bcbc;
            line-height: 1.4em;
            font-size: 0.95em;
            overflow-x: auto;
            white-space: pre;
            -webkit-overflow-scrolling: touch;
            word-wrap: normal;
        }

        pre code .keyword {
            color: #e73289;
        }

        pre code .type {
            color: #8281ca;
        }

        pre code .call {
            color: #348fe5;
        }

        pre code .property {
            color: #21ab9d;
        }

        pre code .number {
            color: #db6f57;
        }

        pre code .string {
            color: #fa641e;
        }

        pre code .comment {
            color: #6b8a94;
        }

        pre code .dotAccess {
            color: #92b300;
        }

        pre code .preprocessing {
            color: #b68a00;
        }
        </style>
        <html>
         <head>
          <meta charset="utf-8">
         </head>
         <body>
          <pre><code class="language-swift"><span class="keyword">func</span> helloWorld() {}</code></pre> 
         </body>
        </html>
        """
        
        let convertedText = try convertToHTML(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToHTML_MultipleLinesOfCode() throws {
        let source = """

        func helloWorld() {
            print("Hello, World!")

        }

        """
        
        let expectedConvertedText = """
        <style type="text/css" media="screen">
        pre {
            margin-bottom: 1.5em;
            background-color: #1a1a1a;
            padding: 16px 0;
            border-radius: 16px;
            word-wrap: normal;
        }

        pre code {
            font-family: monospace;
            display: block;
            padding: 0 20px;
            color: #a9bcbc;
            line-height: 1.4em;
            font-size: 0.95em;
            overflow-x: auto;
            white-space: pre;
            -webkit-overflow-scrolling: touch;
            word-wrap: normal;
        }

        pre code .keyword {
            color: #e73289;
        }

        pre code .type {
            color: #8281ca;
        }

        pre code .call {
            color: #348fe5;
        }

        pre code .property {
            color: #21ab9d;
        }

        pre code .number {
            color: #db6f57;
        }

        pre code .string {
            color: #fa641e;
        }

        pre code .comment {
            color: #6b8a94;
        }

        pre code .dotAccess {
            color: #92b300;
        }

        pre code .preprocessing {
            color: #b68a00;
        }
        </style>
        <html>
         <head>
          <meta charset="utf-8">
         </head>
         <body>
          <pre><code class="language-swift"><span class="keyword">func</span> helloWorld() {
            <span class="call">print</span>(<span class="string">"Hello,</span> <span class="string">World!"</span>)

        }</code></pre> 
         </body>
        </html>
        """
        
        let convertedText = try convertToHTML(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToHTML_SingleLineOfMarkdown() throws {
        let source = """
        //: ## Hello World ##
        """
        
        let expectedConvertedText = """
        <style type="text/css" media="screen">
        pre {
            margin-bottom: 1.5em;
            background-color: #1a1a1a;
            padding: 16px 0;
            border-radius: 16px;
            word-wrap: normal;
        }

        pre code {
            font-family: monospace;
            display: block;
            padding: 0 20px;
            color: #a9bcbc;
            line-height: 1.4em;
            font-size: 0.95em;
            overflow-x: auto;
            white-space: pre;
            -webkit-overflow-scrolling: touch;
            word-wrap: normal;
        }

        pre code .keyword {
            color: #e73289;
        }

        pre code .type {
            color: #8281ca;
        }

        pre code .call {
            color: #348fe5;
        }

        pre code .property {
            color: #21ab9d;
        }

        pre code .number {
            color: #db6f57;
        }

        pre code .string {
            color: #fa641e;
        }

        pre code .comment {
            color: #6b8a94;
        }

        pre code .dotAccess {
            color: #92b300;
        }

        pre code .preprocessing {
            color: #b68a00;
        }
        </style>
        <html>
         <head>
          <meta charset="utf-8">
         </head>
         <body>
          <h2>Hello World</h2> 
         </body>
        </html>
        """
        
        let convertedText = try convertToHTML(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToHTML_MultipleLinesOfMarkdown() throws {
        let source = """
        /*:
        ## Hello, World ##
        It's a-me, a-Mario!
        */
        """
        
        let expectedConvertedText = """
        <style type="text/css" media="screen">
        pre {
            margin-bottom: 1.5em;
            background-color: #1a1a1a;
            padding: 16px 0;
            border-radius: 16px;
            word-wrap: normal;
        }

        pre code {
            font-family: monospace;
            display: block;
            padding: 0 20px;
            color: #a9bcbc;
            line-height: 1.4em;
            font-size: 0.95em;
            overflow-x: auto;
            white-space: pre;
            -webkit-overflow-scrolling: touch;
            word-wrap: normal;
        }

        pre code .keyword {
            color: #e73289;
        }

        pre code .type {
            color: #8281ca;
        }

        pre code .call {
            color: #348fe5;
        }

        pre code .property {
            color: #21ab9d;
        }

        pre code .number {
            color: #db6f57;
        }

        pre code .string {
            color: #fa641e;
        }

        pre code .comment {
            color: #6b8a94;
        }

        pre code .dotAccess {
            color: #92b300;
        }

        pre code .preprocessing {
            color: #b68a00;
        }
        </style>
        <html>
         <head>
          <meta charset="utf-8">
         </head>
         <body>
          <h2>Hello, World</h2> 
          <p>It's a-me, a-Mario!</p> 
         </body>
        </html>
        """
        
        let convertedText = try convertToHTML(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    func testConvertToHTML_MultipleLinesOfMarkdownAndCode() throws {
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
        <style type="text/css" media="screen">
        pre {
            margin-bottom: 1.5em;
            background-color: #1a1a1a;
            padding: 16px 0;
            border-radius: 16px;
            word-wrap: normal;
        }

        pre code {
            font-family: monospace;
            display: block;
            padding: 0 20px;
            color: #a9bcbc;
            line-height: 1.4em;
            font-size: 0.95em;
            overflow-x: auto;
            white-space: pre;
            -webkit-overflow-scrolling: touch;
            word-wrap: normal;
        }

        pre code .keyword {
            color: #e73289;
        }

        pre code .type {
            color: #8281ca;
        }

        pre code .call {
            color: #348fe5;
        }

        pre code .property {
            color: #21ab9d;
        }

        pre code .number {
            color: #db6f57;
        }

        pre code .string {
            color: #fa641e;
        }

        pre code .comment {
            color: #6b8a94;
        }

        pre code .dotAccess {
            color: #92b300;
        }

        pre code .preprocessing {
            color: #b68a00;
        }
        </style>
        <html>
         <head>
          <meta charset="utf-8">
         </head>
         <body>
          <h2>Hello, World</h2> 
          <p>It's a-me, a-Mario!</p> 
          <pre><code class="language-swift"><span class="keyword">func</span> helloWorld() {
            <span class="call">print</span>(<span class="string">"Hello,</span> <span class="string">World!"</span>)
        }</code></pre> 
         </body>
        </html>
        """
        
        let convertedText = try convertToHTML(from: source)
        
        XCTAssertEqual(convertedText, expectedConvertedText)
    }
    
    static var allTests = [
        ("testConvertToHTML_SingleLineOfCode", testConvertToHTML_SingleLineOfCode),
        ("testConvertToHTML_MultipleLinesOfCode", testConvertToHTML_MultipleLinesOfCode),
        ("testConvertToHTML_SingleLineOfMarkdown", testConvertToHTML_SingleLineOfMarkdown),
        ("testConvertToHTML_MultipleLinesOfMarkdown", testConvertToHTML_MultipleLinesOfMarkdown),
    ]
}
