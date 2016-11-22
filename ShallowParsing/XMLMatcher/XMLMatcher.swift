// XMLMatcher.swift
//
// Copyright (c) 2016 Hèctor Marquès Ranea
//
// This software contains derived code from:
// Robert D. Cameron "REX: XML Shallow Parsing with Regular Expressions",
// Technical Report TR 1998-17, School of Computing Science, Simon Fraser
// University, November, 1998.
// Copyright (c) 1998, Robert D. Cameron.
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

/// Shallow Parsing matcher (see <http://www.cs.sfu.ca/%7Ecameron/REX.html>).
/// Based on the Python port made by Paul Prescod:
///
/// <http://code.activestate.com/recipes/65125-xml-lexing-shallow-parsing/>.
public struct XMLMatcher: Matcher {
    
    public typealias MatchToken = XMLToken
    
    static let TextSE = "[^<]+"
    static let UntilHyphen = "[^-]*-"
    static let Until2Hyphens = "\(UntilHyphen)(?:[^-]\(UntilHyphen))*-"
    static let CommentCE = "\(Until2Hyphens)>?"
    static let UntilRSBs = "[^\\]]*](?:[^\\]]+])*]+"
    static let CDATA_CE = "\(UntilRSBs)(?:[^\\]>]\(UntilRSBs))*>"
    static let S = "[ \\n\\t\\r]+"
    static let NameStrt = "[A-Za-z_:]|[^\\x00-\\x7F]"
    static let NameChar = "[A-Za-z0-9_:.-]|[^\\x00-\\x7F]"
    static let Name = "(?:\(NameStrt))(?:\(NameChar))*"
    static let QuoteSE = "\"[^\"]*\"|'[^']*'"
    static let DT_IdentSE = "\(S)\(Name)(?:\(S)(?:\(Name)|\(QuoteSE)))*"
    static let MarkupDeclCE = "(?:[^\\]\"'><]+|\(QuoteSE))*>"
    static let S1 = "[\\n\\r\\t ]"
    static let UntilQMs = "[^?]*\\?+"
    static let PI_Tail = "\\?>|\(S1)\(UntilQMs)(?:[^>?]\(UntilQMs))*>"
    static let DT_ItemSE = "<(?:!(?:--\(Until2Hyphens)>|[^-]\(MarkupDeclCE))|\\?\(Name)(?:\(PI_Tail)))|%%\(Name);|\(S)"
    static let DocTypeCE = "\(DT_IdentSE)(?:\(S))?(?:\\[(?:\(DT_ItemSE))*](?:\(S))?)?>?"
    static let DeclCE = "--(?:\(CommentCE))?|\\[CDATA\\[(?:\(CDATA_CE))?|DOCTYPE(?:\(DocTypeCE))?"
    static let PI_CE = "\(Name)(?:\(PI_Tail))?"
    static let EndTagCE = "\(Name)(?:\(S))?>?"
    static let AttValSE = "\"[^<\"]*\"|'[^<']*'"
    static let ElemTagCE = "\(Name)(?:\(S)\(Name)(?:\(S))?=(?:\(S))?(?:\(AttValSE)))*(?:\(S))?/?>?"
    static let MarkupSPE = "<(?:!(?:\(DeclCE))?|\\?(?:\(PI_CE))?|/(?:\(EndTagCE))?|(?:\(ElemTagCE))?)"
    
    static let XML_SPE: Regex = try! Regex(pattern: "\(TextSE)|\(MarkupSPE)")
    static let XML_Markup_ONLY_SPE: Regex = try! Regex(pattern: "\(MarkupSPE)")

    let markupOnly: Bool
    
    let mergeMarkers: Bool
    
    public init(mergeMarkers: Bool) {
        self.markupOnly = false
        self.mergeMarkers = mergeMarkers
    }
    
    public init(markupOnly: Bool) {
        self.markupOnly = markupOnly
        self.mergeMarkers = false
    }
        
    public func regex() -> Regex {
        var regex: Regex
        if markupOnly {
            regex = type(of: self).XML_Markup_ONLY_SPE
        } else {
            regex = type(of: self).XML_SPE
        }

        return regex
    }    
}
