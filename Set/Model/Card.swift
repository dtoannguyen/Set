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

    var description: String { return numberUI()}
    
    var isSelected = false
    var isMatched = false
    let number: Int
    let symbol: String
    let shading: String
    let color: UIColor
    
    static var numbers = [1, 2, 3]
    static var symbols = ["■","●","▲"]
    static var shades = ["solid", "striped", "open"]
    static var colors = [UIColor.red, .green, .purple]

    func numberUI() -> String {
        var symbols: String?
        if number == 1 {
            symbols = "\(symbol)"
        } else if number == 2 {
            symbols = "\(symbol)\n\(symbol)"
        } else if number == 3 {
            symbols = "\(symbol)\n\(symbol)\n\(symbol)"
        }
        return symbols!
    }
    
}
