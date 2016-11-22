// Matcher.swift
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

/// Interface for `Regex` based scanners.
public protocol Matcher {

    associatedtype MatchToken: Token
    
    func regex() -> Regex
}

// Evaluator extension.
extension Matcher {
    
    public func tokens(in string: String) -> [MatchToken] {
        let matches = regex().matches(in: string)
        let tokens = matches.map { MatchToken(match: $0) }
        
        return tokens
    }
    
    public static func getAssociatedType() -> MatchToken.Type {
        
        return MatchToken.self
    }
}
