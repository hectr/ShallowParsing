// Regex.swift
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

/// Representation of a regular expression match.
public struct Match {
    
    public let range: Range<String.Index>
    public let value: String
    
    init(range: Range<String.Index>, in string: String) {
        self.range = range
        self.value = string.substring(with: range)
    }
}

// `Match` *is equal* operator.
extension Match: Equatable { }
public func ==(lhs: Match, rhs: Match) -> Bool {
    
    return (lhs.range == rhs.range && lhs.value == rhs.value)
}

/// Wrapper for `NSRegularExpressionOptions`.
/// Derived from: <http://nshipster.com/swift-literal-convertible/>.
public struct Regex {
    
    static let DefaultOptions = NSRegularExpression.Options(rawValue: 0)
    static let DefaultMatchingOptions = NSRegularExpression.MatchingOptions(rawValue: 0)

    public let pattern: String
    public let options: NSRegularExpression.Options
    public let matchingOptions: NSRegularExpression.MatchingOptions

    private let regularExpression: NSRegularExpression
    
    private func textCheckingResults(in string: String) -> [NSTextCheckingResult] {
        let range = NSMakeRange(0, string.utf16.count)
        let results = regularExpression.matches(in: string, options: matchingOptions, range: range)
        
        return results
    }
    
    public init(pattern: String, options: NSRegularExpression.Options? = nil, matchingOptions: NSRegularExpression.MatchingOptions? = nil) throws {
        if let options = options {
            self.options = options
        } else {
            self.options = type(of: self).DefaultOptions
        }
        if let matchingOptions = matchingOptions {
            self.matchingOptions = matchingOptions
        } else {
            self.matchingOptions = type(of: self).DefaultMatchingOptions
        }
        self.pattern = pattern
        self.regularExpression = try NSRegularExpression(pattern: pattern, options: self.options)
    }
    
    public func matches(in string: String) -> [Match] {
        let results = self.textCheckingResults(in: string)
        var matches = [Match]()
        for result in results {
            if let range = string.range(from: result.range) {
                let match = Match(range: range, in: string)
                matches.append(match)
            } else {
                assert(false)
            }
        }
        
        return matches
    }
    
    public func numberOfMatches(in string: String, options optionalOptions: NSRegularExpression.MatchingOptions? = nil) -> Int {
        let options = (optionalOptions != nil ? optionalOptions! : NSRegularExpression.MatchingOptions(rawValue: 0))
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = regularExpression.numberOfMatches(in: string, options: options, range: range)
        
        return matches
    }
}

// TODO: decide what to do with this...
#if false
// Sort of `Regex` literals.
extension Regex: ExpressibleByStringLiteral {
    
    public typealias UnicodeScalarLiteralType = String
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        try! self.init(pattern: "\(value)")
    }
    
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        try! self.init(pattern: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        try! self.init(pattern: value)
    }
}
#endif

// `Regex` *Equal* operator.
extension Regex: Equatable { }
public func ==(lhs: Regex, rhs: Regex) -> Bool {
    
    return (lhs.options == rhs.options && lhs.pattern == rhs.pattern && lhs.matchingOptions == rhs.matchingOptions)
}
