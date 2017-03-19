// XMLToken.swift
//
// Copyright (c) 2016 Hèctor Marquès Ranea
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// Representation of an XML token.
public enum XMLToken {
    case declaration(String, Range<String.Index>)
    case xmlDeclaration(String, Range<String.Index>)
    case processingInstruction(String, Range<String.Index>)
    case endTag(String, Range<String.Index>)
    case emptyTag(String, Range<String.Index>)
    case startTag(String, Range<String.Index>)
    case text(String, Range<String.Index>)
    case error(String, Range<String.Index>)
    
    enum Prefix: String, PrefixProtocol {
        case declaration            = "<!"
        case xmlDeclaration         = "<?xml"
        case processingInstruction  = "<?"
        case endTag                 = "</"
        
        static var firstCharacter: Character {
            
            return "<"
        }
    }
    
    enum Suffix: String, SuffixProtocol {
        case tag           = ">"
        case emptyTag      = "/>"
    }
}

// Conformance to `Token` protocol and token categorization.
extension XMLToken: Token {
    
    public init(match: Match) {
        let value = match.value
        if match.value.characters.first == XMLToken.Prefix.firstCharacter {
            if value.contains(affix: Prefix.declaration) {
                self = XMLToken.declaration(value, match.range)
            } else if value.contains(affix: Prefix.xmlDeclaration) {
                self = XMLToken.xmlDeclaration(value, match.range)
            } else if value.contains(affix: Prefix.processingInstruction) {
                self = XMLToken.processingInstruction(value, match.range)
            } else if value.contains(affix: Prefix.endTag) {
                self = XMLToken.endTag(value, match.range)
            } else if value.contains(affix: Suffix.emptyTag) {
                self = XMLToken.emptyTag(value, match.range)
            } else if value.contains(affix: Suffix.tag) {
                self = XMLToken.startTag(value, match.range)
            } else {
                self = XMLToken.error(value, match.range)
            }
        } else {
            self = XMLToken.text(value, match.range)
        }
    }
    
    func associatedValues() -> (lexeme: String, range: Range<String.Index>) {
        var lexeme: String
        var range: Range<String.Index>
        switch self {
        case .declaration(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .xmlDeclaration(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .processingInstruction(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .endTag(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .emptyTag(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .startTag(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .text(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        case .error(let matchedString, let matchedRange):
            lexeme = matchedString
            range = matchedRange
        }
        
        return (lexeme, range)
    }
    
    public func lexeme() -> String {
        
        return associatedValues().lexeme
    }
    
    public func range() -> Range<String.Index> {
        
        return associatedValues().range
    }
}
