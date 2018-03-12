//
//  Card.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

struct Card: CustomStringConvertible, Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading
    }

    var description: String {
        var symbols: String?
        switch number {
        case .one:
            symbols = "\(symbol.rawValue)"
        case .two:
            symbols = "\(symbol.rawValue) \(symbol.rawValue)"
        case .three:
            symbols = "\(symbol.rawValue) \(symbol.rawValue) \(symbol.rawValue)"
        }
        return symbols!
    }
    
    let number: Numbers
    let symbol: Symbols
    let shading: Shades
    let color: Colors
    
    enum Numbers {
        case one
        case two
        case three
        
        static var all = [Numbers.one, .two, .three]
    }
    
    enum Symbols: String {
        case square = "■"
        case circle = "●"
        case triangle = "▲"
        
        static var all = [Symbols.square, .circle, .triangle]
    }
    
    enum Shades {
        case solid
        case striped
        case open
        
        static var all = [Shades.solid, .striped, .open]
    }
    
    enum Colors {
        case red
        case green
        case purple

        static var all = [Colors.red, .green, .purple]
    }
    
}
