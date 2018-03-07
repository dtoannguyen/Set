//
//  Set.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

struct Set {
    
    var deck = [Card]()
    var cardsOnTheField = [Card]()
    var matchedCards = [Card]()
    var selectedCards = [Card]()
    var indicesOfSelectedCards = [Int]()
    private(set) var score = 0
    private(set) var matches = 0
    
    // TODO: - Append Cards to Deck
    init() {
        for color in Card.colors {
            for symbol in Card.symbols {
                for number in Card.numbers {
                    for shade in Card.shades {
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
//            if (selectedCards[0].color == selectedCards[1].color && selectedCards[0].color == selectedCards[2].color && selectedCards[1].color == selectedCards[2].color) || (selectedCards[0].color != selectedCards[1].color && selectedCards[0].color != selectedCards[2].color && selectedCards[1].color != selectedCards[2].color) {
                print("It's a match!")
                matches += 1
                for card in selectedCards {
                    matchedCards.append(card)
                }
            if matchedCards.count == 81 {
                print("All cards have been appended to matchedCards")
            }
//            } else {
//                print("Cards do not match!")
//            }
        }
    }

    // TODO: - Replace Removed Cards
    mutating func replaceRemovedCardsOnTheField() {
        if !deck.isEmpty && matchedCards.contains(selectedCards[1]) { // Any card of that array would be fine
            print("selectedCard is contained in matchedCards")
            for index in indicesOfSelectedCards {
                cardsOnTheField.remove(at: index)
                let randomCard = deck.remove(at: deck.count.arc4random)
                cardsOnTheField.insert(randomCard, at: index)
            }
            print(deck.count)
        } else {
            print("Deck is either empty or selectedCard is not contained in matchedCards")
        }
    }
    
    // TODO: - Reset selectedCards and indicesOfSelecteCards
    mutating func resetSelectedCards() {
        selectedCards.removeAll()
        indicesOfSelectedCards.removeAll()
    }
    
    // TODO: - Restart game
    
}
