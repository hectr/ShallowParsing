import UIKit
import XCTest
import ShallowParsing

class Tests: XCTestCase {
    
    var lexer: Analyzer<XMLMatcher>!
    var markupOnlyLexer: Analyzer<XMLMatcher>!
    var mergeLexer: Analyzer<XMLMatcher>!
    
    override func setUp() {
        super.setUp()
        lexer = Analyzer<XMLMatcher>(matcher: XMLMatcher(markupOnly: false))
        markupOnlyLexer = Analyzer<XMLMatcher>(matcher: XMLMatcher(markupOnly: true))
        mergeLexer = Analyzer<XMLMatcher>(matcher: XMLMatcher(mergeMarkers: true))
    }
    
    override func tearDown() {
        lexer = nil
        markupOnlyLexer = nil
        mergeLexer = nil
        super.tearDown()
    }
    
    // TODO: implement proper tests...

    func test_emptyTag() {
        let string = "<abc/>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 1)
    }
    
    func test_emptyTagTypeIsCorrect() {
        let string = "<abc/>"
        let tokens: [XMLToken] = lexer.analyze(string)
        var isEmptyTag: Bool
        switch tokens.first! {
        case .emptyTag:
            isEmptyTag = true
        default:
            isEmptyTag = false
        }
        XCTAssertTrue(isEmptyTag)
    }

    func test_emptyTagStringIsCorrect() {
        let string = "<abc />"
        let tokens: [XMLToken] = lexer.analyze(string)
        var emptyTagString: String?
        switch tokens.first! {
        case .emptyTag (let string, _):
            emptyTagString = string
        default:
            XCTFail()
        }
        XCTAssertEqual(emptyTagString, string)
    }

    func test_emptyTagBetweenTags() {
        let string = "<abc><def/></abc>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 3)
    }
    
    func test_textBetweenTags() {
        let string = "<abc>Blah</abc>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 3)
    }
    
    func test_textBetweenTagsMarkupOnly() {
        let string = "<abc>Blah</abc>"
        let tokens = markupOnlyLexer.analyze(string)
        XCTAssertEqual(tokens.count, 2)
    }
    
    func test_XMLDeclarationMarkupOnly() {
        let string = "<?xml version='1.0'?><abc>Blah</abc>"
        let tokens = markupOnlyLexer.analyze(string)
        XCTAssertEqual(tokens.count, 3)
    }
    
    func test_moreText() {
        let string = "<abc>Blah&foo;Blah</abc>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 3)
    }
    
    func test_moreTextMarkupOnly() {
        let string = "<abc>Blah&foo;Blah</abc>"
        let tokens = markupOnlyLexer.analyze(string)
        XCTAssertEqual(tokens.count, 2)
    }
    
    func test_twoOpenTags() {
        let string = "<abc><abc>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 2)
    }
    
    func test_twoCloseTags() {
        let string = "</abc></abc>"
        let tokens = lexer.analyze(string)
        XCTAssertEqual(tokens.count, 2)
    }
    
}
