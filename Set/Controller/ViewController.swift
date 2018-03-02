//
//  ViewController.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()
    var selectedCardIndices = [Int]()
    var lastSelectedCard: Card?
    var lastMatchedCard: Card?
    
    @IBOutlet var openCards: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.drawCardsFromDeck(amountOfCards: 12)
        for buttonIndex in openCards.indices {
            if buttonIndex > 11 {
                openCards[buttonIndex].isHidden = true
            }
        }
        assignCardToButton()
    }
    
    func assignCardToButton() {
        let openCardsOnTheField = openCards.filter {$0.isHidden == false}
        for index in openCardsOnTheField.indices {
            var attributes = [NSAttributedStringKey:Any]()
            let button = openCards[index]
            let card = game.cardsOnTheField[index]
            button.layer.cornerRadius = 8.0
            attributes[NSAttributedStringKey.strokeColor] = card.color
            if card.shading == "solid" {
                attributes[NSAttributedStringKey.foregroundColor] = card.color
            } else if card.shading == "striped" {
                attributes[NSAttributedStringKey.foregroundColor] = card.color.withAlphaComponent(0.4)
                attributes[NSAttributedStringKey.strokeWidth] = -4.0
            } else if card.shading == "open" {
                attributes[NSAttributedStringKey.strokeWidth] = 4.0
            }
            let attributedText = NSAttributedString(string: card.description, attributes: attributes)
            button.setAttributedTitle(attributedText, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 3
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if selectedCardIndices.count == 3 {
            selectedCardIndices.removeAll()
        }
        let openCardsOnTheField = openCards.filter {$0.isHidden == false}
        guard let cardNumber = openCardsOnTheField.index(of: sender) else { print("openCards.index(of: sender) not available"); return }
        game.selectCard(at: cardNumber)
        if game.cardsOnTheField[cardNumber].isSelected == false {
            guard let indexOfCardNumber = selectedCardIndices.index(of: cardNumber) else {print("cardNumber not found in selectedCardIndices"); return}
            lastSelectedCard = nil
            print("lastSelectedCard set to nil")
            selectedCardIndices.remove(at: indexOfCardNumber)
            print(selectedCardIndices)
            openCardsOnTheField[cardNumber].layer.borderWidth = 0
//            openCards[cardNumber].layer.borderWidth = 0
        }
//        print(game.cardsOnTheField[cardNumber])
        if game.cardsOnTheField[cardNumber].isSelected {
            lastSelectedCard = game.cardsOnTheField[cardNumber]
            print(lastSelectedCard!)
            selectedCardIndices.append(cardNumber)
            print(selectedCardIndices)
            openCardsOnTheField[cardNumber].layer.borderWidth = 5
            openCardsOnTheField[cardNumber].layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor
            if selectedCardIndices.count == 3 {
                if let lastCardMatched = lastMatchedCard {
                    if game.matchedCards.contains(lastCardMatched) {
                        print("lastSelectedCard is contained in matched Cards")
                        if game.deck.isEmpty {
                            //                        for index in selectedCardIndices {
                            //                            openCards[index].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
                            //                            openCards.remove(at: index)
                            //                            openCards[index].isHidden = true
                            //                        }
                            for index in 0...2 {
                                openCardsOnTheField[index].isHidden = true
                            }
                        }
                    } else {
                        print("lastSelectedCard is not contained in matched Cards")
                    }
                }
            }
            game.checkIfCardsAreSets()
            if game.matchedCards.contains(lastSelectedCard!) {
                lastMatchedCard = lastSelectedCard!
            }
            if game.cardsOnTheField.filter({ $0.isSelected }).isEmpty {
//                print("No Cards selected")
                for index in selectedCardIndices {
                    openCards[index].layer.borderWidth = 0
                }
                assignCardToButton()
            }
        }
    }
    
    @IBAction func dealThreeMoreCardsButtonPressed(_ sender: Any) {
        if game.cardsOnTheField.count < 24 {
            let indicesOfHiddenCardsOnTheField = openCards.indices.filter() {openCards[$0].isHidden == true}
            for index in 0...2 {
                openCards[indicesOfHiddenCardsOnTheField[index]].isHidden = false
            }
            game.drawCardsFromDeck(amountOfCards: 3)
            assignCardToButton()
        }
    }

}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}
