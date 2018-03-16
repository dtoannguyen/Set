//
//  ViewController.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game = Set()
    
    @IBOutlet private weak var cardsInDeckLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    @IBOutlet private var openCards: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealMoreCardsButton.layer.cornerRadius = 8.0
        hintButton.layer.cornerRadius = 8.0
        gameSetup()
    }
    
    private func gameSetup() {
        game.drawCardsFromDeck(amountOfCards: 12)
        updateLabels()
        for buttonIndex in openCards.indices {
            openCards[buttonIndex].backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9215686275, alpha: 1)
            if buttonIndex < 12 {
                openCards[buttonIndex].isHidden = false
                openCards[buttonIndex].layer.borderWidth = 0.0
            } else {
                openCards[buttonIndex].isHidden = true
            }
        }
        assignCardToButton()
    }
    
    private func assignCardToButton() {
        let openCardsOnTheField = openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
        for index in openCardsOnTheField.indices {
            var attributes = [NSAttributedStringKey:Any]()
            let button = openCardsOnTheField[index]
            let card = game.cardsOnTheField[index]
            button.layer.cornerRadius = 8.0
            switch card.color {
            case .green:
                attributes[NSAttributedStringKey.strokeColor] = UIColor.green
            case .purple:
                attributes[NSAttributedStringKey.strokeColor] = UIColor.purple
            case .red:
                attributes[NSAttributedStringKey.strokeColor] = UIColor.red
            }
            let cardColor: UIColor = attributes[NSAttributedStringKey.strokeColor] as! UIColor
            switch card.shading {
            case .solid:
                attributes[NSAttributedStringKey.foregroundColor] = cardColor
            case .striped:
                attributes[NSAttributedStringKey.foregroundColor] = cardColor.withAlphaComponent(0.4)
                attributes[NSAttributedStringKey.strokeWidth] = -4.0
            case .open:
                attributes[NSAttributedStringKey.strokeWidth] = 4.0
            }
            let attributedText = NSAttributedString(string: card.description, attributes: attributes)
            button.setAttributedTitle(attributedText, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 3
        }
    }
    
    @IBAction private func selectCard(_ sender: UIButton) {
        let openCardsOnTheField = openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
        guard let cardNumber = openCardsOnTheField.index(of: sender) else { print("sender not available"); return }
        let selection = game.cardsOnTheField[cardNumber]
        game.selectCard(at: cardNumber)
        makeSelectionVisible(filteredArray: openCardsOnTheField, at: cardNumber, selectedCard: selection)
        print("Last selected card: \n\(selection)")
        if game.selectedCards.count == 3 {
            game.checkIfCardsAreSets()
            for index in game.indicesOfSelectedCards {
                openCardsOnTheField[index].layer.borderWidth = 0
            }
            if game.matchedCards.contains(selection) {
                print("VC recognized match")
                if game.deck.isEmpty {
                    for index in game.indicesOfSelectedCards {
                        openCardsOnTheField[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                        openCardsOnTheField[index].setAttributedTitle(nil, for: .normal)
//                        openCardsOnTheField[index].isHidden = true
                    }
                }
            } else {
                print("VC does NOT recognized match")
            }
            game.replaceRemovedCardsOnTheField()
            game.resetSelectedCards()
            assignCardToButton()
            updateLabels()
        }
    }
    
    private func makeSelectionVisible(filteredArray: [UIButton],at selectedIndex: Int, selectedCard: Card) {
        if !game.selectedCards.contains(selectedCard) {
            filteredArray[selectedIndex].layer.borderWidth = 0
        } else {
            filteredArray[selectedIndex].layer.borderWidth = 3.5
            filteredArray[selectedIndex].layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.5176470588, blue: 0.1019607843, alpha: 1).cgColor
        }
    }

    @IBAction private func dealThreeMoreCardsButtonPressed(_ sender: Any) {
        if game.cardsOnTheField.count < 24 && !game.deck.isEmpty {
            let indicesOfHiddenCardsOnTheField = openCards.indices.filter() {openCards[$0].isHidden == true}
            for index in 0...2 {
                openCards[indicesOfHiddenCardsOnTheField[index]].isHidden = false
            }
            game.drawCardsFromDeck(amountOfCards: 3)
            assignCardToButton()
            updateLabels()
        }
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        game = Set()
        gameSetup()
    }
    

    private func updateLabels() {
        cardsInDeckLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @IBAction private func hintButtonPressed(_ sender: UIButton) {
        game.hint()
        if !game.selectedCards.isEmpty {
            let openCardsOnTheField = openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
            for index in game.selectedCards.indices {
                openCardsOnTheField[game.indicesOfSelectedCards[index]].layer.borderWidth = 3.5
                openCardsOnTheField[game.indicesOfSelectedCards[index]].layer.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
//                makeSelectionVisible(filteredArray: openCardsOnTheField, at: game.indicesOfSelectedCards[index], selectedCard: game.selectedCards[index])
            }
            game.resetSelectedCards()
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
