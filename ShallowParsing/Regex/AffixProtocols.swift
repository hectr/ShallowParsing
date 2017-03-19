// AffixProtocols.swift
//
// Copyright (c) 2017 Hèctor Marquès Ranea
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

public protocol AffixProtocol {
    
    var rawValue: String { get }
    
    var length: Int { get }
}

extension AffixProtocol {
    
    var length: Int {
        
        return rawValue.characters.count
    }
}

public protocol PrefixProtocol: AffixProtocol { }

public protocol SuffixProtocol: AffixProtocol { }

// Affix protocols additions to `String`.
extension String {
    
    func index(of prefix: PrefixProtocol) -> Index? {
        if characters.count < prefix.length {
            
            return nil
        }
        let index =  characters.index(startIndex, offsetBy: prefix.length)
        
        return index
    }
    
    func index(of suffix: SuffixProtocol) -> Index? {
        if characters.count < suffix.length {
            
            return nil
        }
        let index = characters.index(endIndex, offsetBy: -suffix.length)
        
        return index
    }
    
    func contains(affix prefix: PrefixProtocol) -> Bool {
        guard let to = index(of: prefix) else {
            
            return false
        }
        let contains = (substring(to: to) == prefix.rawValue)
        
        return contains
    }
    
    func contains(affix suffix: SuffixProtocol) -> Bool {
        guard let from = index(of: suffix) else {
            
            return false
        }
        let contains = (substring(from: from) == suffix.rawValue)
        
        return contains
    }
}
