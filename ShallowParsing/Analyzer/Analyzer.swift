// Analyzer.swift
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

/// Generic lexical analyzer. 
public struct Analyzer<M: Matcher> {
    
    private var matcher: M
    
    public init(matcher: M) {
        self.matcher = matcher
    }
    
    public func analyze(_ string: String, callback: (M.MatchToken) -> Void) {
        let tokens = matcher.tokens(in: string)
        for token in tokens {
            callback(token)
        }
    }
    
    public func analyze(_ string: String) -> [M.MatchToken] {
        var tokens = Array<M.MatchToken>()
        analyze(string) { token in
            tokens.append(token)
        }
        
        return tokens
    }
}
