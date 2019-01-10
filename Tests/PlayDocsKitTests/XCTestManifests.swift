import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConvertTests.allTests),
        testCase(ConvertToHTMLTests.allTests),
        testCase(ConvertToMarkdownTests.allTests),
    ]
}
#endif
