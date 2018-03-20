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
    
    // MARK: - Append Cards to Deck
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
    
    // MARK: - Select Card
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
    
    // MARK: - Check if selected cards form a set or not
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

    // MARK: - Replace Removed Cards
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
    
    // MARK: - Reset selectedCards and indicesOfSelecteCards
    mutating func resetSelectedCards() {
        selectedCards.removeAll()
        indicesOfSelectedCards.removeAll()
    }
    
    // MARK: - Hint / Solution
    mutating func hint() {
        resetSelectedCards()
        var startIndex = cardsOnTheField.count.arc4random
        while startIndex > (cardsOnTheField.count - 3) {
            startIndex = cardsOnTheField.count.arc4random
        }
        outterLoop: for index in 1...(cardsOnTheField.count - 2) {
            let card = cardsOnTheField[startIndex]
            selectedCards.append(card)
            indicesOfSelectedCards.append(startIndex)
            for secondIndex in (startIndex + 1)...(cardsOnTheField.count - 1) {
                selectedCards.append(cardsOnTheField[secondIndex])
                indicesOfSelectedCards.append(secondIndex)
                let first = selectedCards[0]
                let second = selectedCards[1]
                let number = first.number == second.number ? first.number : Card.Numbers.all.filter({$0 != first.number && $0 != second.number})[0]
                let symbol = first.symbol == second.symbol ? first.symbol : Card.Symbols.all.filter({$0 != first.symbol && $0 != second.symbol})[0]
                let shade = first.shading == second.shading ? first.shading : Card.Shades.all.filter({$0 != first.shading && $0 != second.shading})[0]
                let color = first.color == second.color ? first.color : Card.Colors.all.filter({$0 != first.color && $0 != second.color})[0]
                let matchingCard = Card(number: number, symbol: symbol, shading: shade, color: color)
                if cardsOnTheField.contains(matchingCard) {
                    selectedCards.append(matchingCard)
                    let indexOfMatchingCard = cardsOnTheField.index(of: matchingCard)
                    indicesOfSelectedCards.append(indexOfMatchingCard!)
                    print("There is a set on the field")
                    print("Breaking")
                    break outterLoop
                } else {
                    selectedCards.remove(at: 1)
                    indicesOfSelectedCards.remove(at: 1)
                    if index == (cardsOnTheField.count - 2) && secondIndex == (cardsOnTheField.count - 1) {
                        print("Currently there are no cards on the field that makes up a set")
                    } else {
                        print("No matching cards for card with index \(startIndex)/\(secondIndex)could be found")
                    }
                }
            }
            startIndex += 1
            if startIndex == cardsOnTheField.count - 2 {
                startIndex = 0
            }
            selectedCards.remove(at: 0)
            indicesOfSelectedCards.remove(at: 0)
        }
    }
    
}
