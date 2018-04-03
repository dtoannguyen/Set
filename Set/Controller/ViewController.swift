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
    private var playerSelectedThreeCards = false
    private var openCards = [UIButton]()
    private lazy var grid = Grid.init(layout: .aspectRatio(0.8), frame: cardView.bounds)
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet private weak var computerState: UILabel!
    @IBOutlet private weak var cardsInDeckLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet weak var playAgainstComputerButton: UIButton!
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealMoreCardsButton.layer.cornerRadius = 8.0
        hintButton.layer.cornerRadius = 8.0
        playAgainstComputerButton.layer.cornerRadius = 8.0
        gameSetup()
        setupCardView()
    }
    
    // Gets triggered when change in layout of subviews is detected
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCardView()
    }
    
    private func setupCardView() {
        grid.frame = cardView.bounds
        grid.cellCount = game.cardsOnTheField.count
        
        for subview in cardView.subviews {
            subview.removeFromSuperview()
        }
        
        for index in 0..<grid.cellCount {
            if let cellFrame = grid[index] {
                let cardOnTheField = game.cardsOnTheField[index]
                let card = CardSubView.init(frame: cellFrame.insetBy(dx: 1, dy: 1))
                card.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                let colorDict: [Card.Colors : UIColor] = [.red : UIColor.red, .green : UIColor.green, .purple : UIColor.purple]
                let shadeDict: [Card.Shades : String] = [Card.Shades.open : "open", Card.Shades.solid : "solid", Card.Shades.striped : "striped"]
                let numberDict: [Card.Numbers : Int] = [.one : 1, .two : 2, .three : 3]
                let symbolDict: [Card.Symbols : String] = [.triangle : "diamond", .square : "squiggle", .circle : "circle"]
                card.color = colorDict[cardOnTheField.color]
                card.shade = shadeDict[cardOnTheField.shading]
                card.symbol = symbolDict[cardOnTheField.symbol]
                card.number = numberDict[cardOnTheField.number]
                cardView.addSubview(card)
            }
        }
    }
    
    private func gameSetup() {
//        for _ in 1...12 {
//            let button = UIButton()
//            openCards.append(button)
//        }
        game.drawCardsFromDeck(amountOfCards: 12)
        updateLabels()
//        for buttonIndex in openCards.indices {
//            openCards[buttonIndex].backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9215686275, alpha: 1)
//            if buttonIndex < 12 {
//                openCards[buttonIndex].isHidden = false
//                openCards[buttonIndex].layer.borderWidth = 0.0
//            } else {
//                openCards[buttonIndex].isHidden = true
//            }
//        }
        assignCardToButton()
        computerState.text = ""
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
                playerSelectedThreeCards = true
                print("VC recognized match")
                if game.deck.isEmpty {
                    for index in game.indicesOfSelectedCards {
                        openCardsOnTheField[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                        openCardsOnTheField[index].setAttributedTitle(nil, for: .normal)
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
        if !game.deck.isEmpty {
//            let indicesOfHiddenCardsOnTheField = openCards.indices.filter() {openCards[$0].isHidden == true}
//            for index in 0...2 {
//                openCards[indicesOfHiddenCardsOnTheField[index]].isHidden = false
//            }
            game.drawCardsFromDeck(amountOfCards: 3)
            setupCardView()
            assignCardToButton()
            updateLabels()
            cardView.setNeedsDisplay()
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
        let openCardsOnTheField = openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
        for card in openCardsOnTheField {
            card.layer.borderWidth = 0.0
        }
        game.hint()
        if !game.selectedCards.isEmpty {
            for index in game.selectedCards.indices {
                openCardsOnTheField[game.indicesOfSelectedCards[index]].layer.borderWidth = 3.5
                openCardsOnTheField[game.indicesOfSelectedCards[index]].layer.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1).cgColor
            }
            game.resetSelectedCards()
        }
        updateLabels()
    }
    
    @IBAction func playAgainstComputerButtonPressed(_ sender: UIButton) {
        game.computerModusIsOn = game.computerModusIsOn == true ? false : true
        print("computerModusIsOn: \(game.computerModusIsOn)")
        let randomTime = [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
        var seconds = randomTime[randomTime.count.arc4random]
        var startSeconds = seconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.game.computerModusIsOn {
                if seconds == 3 {
                    self.computerState.text = "😁"
                } else if seconds == (startSeconds - 1) {
                    self.computerState.text = "🤔"
                }
                seconds -= 1
                print(seconds)
                if self.playerSelectedThreeCards {
                    print("Player selected three cards")
                    seconds = randomTime[randomTime.count.arc4random]
                    self.playerSelectedThreeCards = false
                }
                if seconds == 0 {
                    self.game.computerPickedFirst = true
                    self.computerState.text = "😋"
                    let openCardsOnTheField = self.openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
                    if !self.game.selectedCards.isEmpty {
                        for index in self.game.indicesOfSelectedCards {
                            openCardsOnTheField[index].layer.borderWidth = 0
                        }
                    }
                    self.game.hint()
                    if self.game.selectedCards.count == 3 {
                        self.game.checkIfCardsAreSets()
                        if self.game.matchedCards.contains(self.game.selectedCards[0]) {
                            if self.game.deck.isEmpty {
                                for index in self.game.indicesOfSelectedCards {
                                    openCardsOnTheField[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                                    openCardsOnTheField[index].setAttributedTitle(nil, for: .normal)
                                }
                            }
                        }
                        self.game.replaceRemovedCardsOnTheField()
                        self.game.resetSelectedCards()
                        self.assignCardToButton()
                        self.updateLabels()
                    }
                    print("Play against computer")
                    self.game.computerPickedFirst = false
                    seconds = randomTime[randomTime.count.arc4random]
                    startSeconds = seconds
                }
            } else {
                timer.invalidate()
                print("Timer deactivated")
            }
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
