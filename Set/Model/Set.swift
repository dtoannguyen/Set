//
//  Set.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

struct Set {
    
    private(set) var deck = [Card]()
    private(set) var cardsOnTheField = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var indicesOfSelectedCards = [Int]()
    private(set) var score = 0
    private(set) var matches = 0
    
    private var cardsAreSets: (Card, Card, Card) -> Bool = {
        return ((($0.color == $1.color && $0.color == $2.color) || ($0.color != $1.color && $0.color != $2.color && $1.color != $2.color)) &&
            (($0.number == $1.number && $0.number == $2.number) || ($0.number != $1.number && $0.number != $2.number && $1.number != $2.number)) &&
            (($0.symbol == $1.symbol && $0.symbol == $2.symbol) || ($0.symbol != $1.symbol && $0.symbol != $2.symbol && $1.symbol != $2.symbol)) &&
            (($0.shading == $1.shading && $0.shading == $2.shading) || ($0.shading != $1.shading && $0.shading != $2.shading && $1.shading != $2.shading)))
    }
    
    // TODO: - Append Cards to Deck
    init() {
        for color in Card.Colors.all {
            for symbol in Card.Symbols.all {
                for number in Card.Numbers.all {
                    for shade in Card.Shades.all {
                        let card = Card(number: number, symbol: symbol, shading: shade, color: color)
                        deck.append(card)
                    }
                }
            }
        }
    }
    
    mutating func drawCardsFromDeck(amountOfCards: Int) {
        for _ in 1...amountOfCards {
            let randomCard = deck.remove(at: deck.count.arc4random)
            cardsOnTheField.append(randomCard)
        }
    }
    
    // TODO: - Select Card
    mutating func selectCard(at index: Int) {
        if selectedCards.contains(cardsOnTheField[index]) {
            print("selectedCards contains \(cardsOnTheField[index])")
            let indexOfSelectedCard = selectedCards.index(of: cardsOnTheField[index])
            selectedCards.remove(at: indexOfSelectedCard!)
            let indexInIndicesOfSelectedCards = indicesOfSelectedCards.index(of: index)
            indicesOfSelectedCards.remove(at: indexInIndicesOfSelectedCards!)
        } else {
            selectedCards.append(cardsOnTheField[index])
            indicesOfSelectedCards.append(index)
        }
        print(indicesOfSelectedCards)
    }
    
    // TODO: - Check if selected cards form a set or not
    mutating func checkIfCardsAreSets() {
        if selectedCards.count < 3 {
            print("There are not enough cards selected")
        }
        if selectedCards.count == 3 {
            if cardsAreSets(selectedCards[0], selectedCards[1], selectedCards[2]) {
                print("It's a match!")
                score += 3
                for card in selectedCards {
                    matchedCards.append(card)
                }
                if matchedCards.count == 81 {
                    print("All cards have been appended to matchedCards")
                }
            } else {
                print("Cards do not match!")
                score -= 5
            }
        }
    }

    // TODO: - Replace Removed Cards
    mutating func replaceRemovedCardsOnTheField() {
        if matchedCards.contains(selectedCards[1]) { // Any card of that array would be fine
            print("selectedCard is contained in matchedCards")
            let sortedIndicesOfSelectedCards = indicesOfSelectedCards.sorted()
            for index in 0...2 {
                if !deck.isEmpty {
                    cardsOnTheField.remove(at: sortedIndicesOfSelectedCards[index])
                    let randomCard = deck.remove(at: deck.count.arc4random)
                    cardsOnTheField.insert(randomCard, at: sortedIndicesOfSelectedCards[index])
                } else {
                    cardsOnTheField.remove(at: sortedIndicesOfSelectedCards[index] - index)
                }
            }
//            print(deck.count)
        } else {
            print("selectedCard is not contained in matchedCards")
        }
    }
    
    // TODO: - Reset selectedCards and indicesOfSelecteCards
    mutating func resetSelectedCards() {
        selectedCards.removeAll()
        indicesOfSelectedCards.removeAll()
    }
    
}
