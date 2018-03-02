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
    private(set) var score = 0
    private(set) var matches = 0
    
    // TODO: - Append Cards to Deck
    init() {
        for color in Card.colors {
            for symbol in Card.symbols {
                for number in Card.numbers {
                    for shade in Card.shades {
                        let card = Card(isSelected: false, isMatched: false, number: number, symbol: symbol, shading: shade, color: color)
                        deck.append(card)
                    }
                }
            }
        }
//        print("Deck has \(deck.count) cards")
    }
    
    mutating func drawCardsFromDeck(amountOfCards: Int) {
        for _ in 1...amountOfCards {
            let randomCard = deck.remove(at: deck.count.arc4random)
            cardsOnTheField.append(randomCard)
        }
    }
    
    // TODO: - Select Card
    mutating func selectCard(at index: Int) {
        cardsOnTheField[index].isSelected = cardsOnTheField[index].isSelected ? false : true
//        print("selectedCard.isSelected = \(cardsOnTheField[index].isSelected)")
    }
    
    // TODO: - Check if selected cards form a set or not
    mutating func checkIfCardsAreSets() {
        let indicesOfSelectedCards = cardsOnTheField.indices.filter {cardsOnTheField[$0].isSelected}
        if indicesOfSelectedCards.count < 3 {
//            print("There are not enough cards selected")
        }
        if indicesOfSelectedCards.count == 3 {
//            if (cardsOnTheField[indicesOfSelectedCards[0]].color == cardsOnTheField[indicesOfSelectedCards[1]].color && cardsOnTheField[indicesOfSelectedCards[0]].color == cardsOnTheField[indicesOfSelectedCards[2]].color && cardsOnTheField[indicesOfSelectedCards[1]].color == cardsOnTheField[indicesOfSelectedCards[2]].color) || (cardsOnTheField[indicesOfSelectedCards[0]].color != cardsOnTheField[indicesOfSelectedCards[1]].color && cardsOnTheField[indicesOfSelectedCards[1]].color != cardsOnTheField[indicesOfSelectedCards[2]].color && cardsOnTheField[indicesOfSelectedCards[0]].color != cardsOnTheField[indicesOfSelectedCards[2]].color), (cardsOnTheField[indicesOfSelectedCards[0]].symbol == cardsOnTheField[indicesOfSelectedCards[1]].symbol && cardsOnTheField[indicesOfSelectedCards[0]].symbol == cardsOnTheField[indicesOfSelectedCards[2]].symbol && cardsOnTheField[indicesOfSelectedCards[1]].symbol == cardsOnTheField[indicesOfSelectedCards[2]].symbol) || (cardsOnTheField[indicesOfSelectedCards[0]].symbol != cardsOnTheField[indicesOfSelectedCards[1]].symbol && cardsOnTheField[indicesOfSelectedCards[1]].symbol != cardsOnTheField[indicesOfSelectedCards[2]].symbol && cardsOnTheField[indicesOfSelectedCards[0]].symbol != cardsOnTheField[indicesOfSelectedCards[2]].symbol), (cardsOnTheField[indicesOfSelectedCards[0]].shading == cardsOnTheField[indicesOfSelectedCards[1]].shading && cardsOnTheField[indicesOfSelectedCards[0]].shading == cardsOnTheField[indicesOfSelectedCards[2]].shading && cardsOnTheField[indicesOfSelectedCards[1]].shading == cardsOnTheField[indicesOfSelectedCards[2]].shading) || (cardsOnTheField[indicesOfSelectedCards[0]].shading != cardsOnTheField[indicesOfSelectedCards[1]].shading && cardsOnTheField[indicesOfSelectedCards[1]].shading != cardsOnTheField[indicesOfSelectedCards[2]].shading && cardsOnTheField[indicesOfSelectedCards[0]].shading != cardsOnTheField[indicesOfSelectedCards[2]].shading), (cardsOnTheField[indicesOfSelectedCards[0]].number == cardsOnTheField[indicesOfSelectedCards[1]].number && cardsOnTheField[indicesOfSelectedCards[0]].number == cardsOnTheField[indicesOfSelectedCards[2]].number && cardsOnTheField[indicesOfSelectedCards[1]].number == cardsOnTheField[indicesOfSelectedCards[2]].number) || (cardsOnTheField[indicesOfSelectedCards[0]].number != cardsOnTheField[indicesOfSelectedCards[1]].number && cardsOnTheField[indicesOfSelectedCards[1]].number != cardsOnTheField[indicesOfSelectedCards[2]].number && cardsOnTheField[indicesOfSelectedCards[0]].number != cardsOnTheField[indicesOfSelectedCards[2]].number) {
                cardsOnTheField[indicesOfSelectedCards[0]].isMatched = true
                cardsOnTheField[indicesOfSelectedCards[1]].isMatched = true
                cardsOnTheField[indicesOfSelectedCards[2]].isMatched = true
                print("It's a match!")
                matches += 1
                for index in 0...2 {
                    let indexOfCardOnTheField = indicesOfSelectedCards[index]
                    cardsOnTheField[indexOfCardOnTheField].isSelected = false
                    print("Append \(cardsOnTheField[indexOfCardOnTheField]) to matchedCards")
                    matchedCards.append(cardsOnTheField.remove(at: indexOfCardOnTheField))
                    if !deck.isEmpty {
                        let randomCard = deck.remove(at: deck.count.arc4random)
//                        print(randomCard)
                        cardsOnTheField.insert(randomCard, at: indicesOfSelectedCards[index])
                    }
                }
//                print(matches)
            print(deck.count)
//            } else {
//                print("No Match")
//            for index in 0...2 {
//                cardsOnTheField[indicesOfSelectedCards[index]].isSelected = false
//                print(cardsOnTheField[indicesOfSelectedCards[index]].isSelected)
//            }
//            print("Selected Cards are deselected")
//            }

        }
    }
    
//    func checkIfCardsHaveEqualAttribute() {
//        let selectedCards = deck.filter {$0.isSelected}
//        for card in selectedCards {
//            // Card.color is equal to color of selectedCards[0]
//        }
//    }
    
    
    // TODO: - Restart game
    
}
