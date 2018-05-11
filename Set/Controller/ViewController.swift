//
//  ViewController.swift
//  Set
//
//  Created by Toan Nguyen on 09.02.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    private var game = Set()
    private var playerSelectedThreeCards = false // needed for playing against computer
    private lazy var grid = Grid.init(layout: .aspectRatio(0.8), frame: cardView.bounds)
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectCard))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            cardView.addGestureRecognizer(tap)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCardsWithGesture))
            swipeDown.direction = .down
            swipeDown.numberOfTouchesRequired = 2
            cardView.addGestureRecognizer(swipeDown)
            
            let twoFingerRotation = UIRotationGestureRecognizer(target: self, action: #selector(reshuffleCardsOnTheField))
            cardView.addGestureRecognizer(twoFingerRotation)
        }
    }
    
    @IBOutlet private weak var computerState: UILabel!
    @IBOutlet private weak var cardsInDeckLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet weak var playAgainstComputerButton: UIButton!
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealMoreCardsButton.layer.cornerRadius = 8.0
        hintButton.layer.cornerRadius = 8.0
        playAgainstComputerButton.layer.cornerRadius = 8.0
        gameSetup()
    }
    
    // MARK: - Setup
    
    private func gameSetup() {
        game.drawCardsFromDeck(amountOfCards: 12)
        updateLabels()
        computerState.text = ""
        updateCardView()
    }

    private func updateLabels() {
        cardsInDeckLabel.text = "Deck: \(game.deck.count)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    // MARK: - Updating Card View
    private func updateCardView() {
        grid.frame = cardView.bounds
        grid.cellCount = game.cardsOnTheField.count
        
        // old subviews have to be removed otherwise there will be multiples of the same card
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
    
    // MARK: - Show Selection
    private func makeSelectionVisible(at index: Int) {
        if game.indicesOfSelectedCards.contains(index) {
            cardView.subviews[index].layer.borderWidth = 4
            cardView.subviews[index].layer.cornerRadius = 8
            cardView.subviews[index].layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            cardView.subviews[index].layer.borderWidth = 0
        }
    }
    
    // MARK: - Deal Cards
    private func dealThreeMoreCards() {
        if !game.deck.isEmpty {
            game.drawCardsFromDeck(amountOfCards: 3)
            updateCardView()
            updateLabels()
        }
    }
    
    // MARK: - Detecting Changes in Layout of Subviews
    
    // gets triggered when change in layout of subviews is detected
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCardView()
    }
    
    // MARK: - IBActions
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        game = Set()
        gameSetup()
    }
    
    @IBAction private func dealThreeMoreCardsButtonPressed(_ sender: Any) {
        dealThreeMoreCards()
    }
    
    @IBAction private func hintButtonPressed(_ sender: UIButton) {
        for subview in cardView.subviews {
            subview.layer.borderWidth = 0
        }
        game.hint()
        if !game.selectedCards.isEmpty {
            for index in game.indicesOfSelectedCards {
                cardView.subviews[index].layer.borderWidth = 4
                cardView.subviews[index].layer.cornerRadius = 8
                cardView.subviews[index].layer.borderColor = UIColor.red.cgColor
            }
            game.resetSelectedCards()
        } else {
            print("There are no sets on the field")
        }
//        scoreLabel.text = "Score: \(self.game.score)"
    }
    
//    @IBAction func playAgainstComputerButtonPressed(_ sender: UIButton) {
//        game.computerModusIsOn = game.computerModusIsOn == true ? false : true
//        print("computerModusIsOn: \(game.computerModusIsOn)")
//        let randomTime = [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
//        var seconds = randomTime[randomTime.count.arc4random]
//        var startSeconds = seconds
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
//            if self.game.computerModusIsOn {
//                if seconds == 3 {
//                    self.computerState.text = "😁"
//                } else if seconds == (startSeconds - 1) {
//                    self.computerState.text = "🤔"
//                }
//                seconds -= 1
//                print(seconds)
//                if self.playerSelectedThreeCards {
//                    print("Player selected three cards")
//                    seconds = randomTime[randomTime.count.arc4random]
//                    self.playerSelectedThreeCards = false
//                }
//                if seconds == 0 {
//                    self.game.computerPickedFirst = true
//                    self.computerState.text = "😋"
//                    let openCardsOnTheField = self.openCards.filter {$0.isHidden == false && $0.backgroundColor != #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)}
//                    if !self.game.selectedCards.isEmpty {
//                        for index in self.game.indicesOfSelectedCards {
//                            openCardsOnTheField[index].layer.borderWidth = 0
//                        }
//                    }
//                    self.game.hint()
//                    if self.game.selectedCards.count == 3 {
//                        self.game.checkIfCardsAreSets()
//                        if self.game.matchedCards.contains(self.game.selectedCards[0]) {
//                            if self.game.deck.isEmpty {
//                                for index in self.game.indicesOfSelectedCards {
//                                    openCardsOnTheField[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//                                    openCardsOnTheField[index].setAttributedTitle(nil, for: .normal)
//                                }
//                            }
//                        }
//                        self.game.replaceRemovedCardsOnTheField()
//                        self.game.resetSelectedCards()
////                        self.assignCardToButton()
//                        self.updateLabels()
//                    }
//                    print("Play against computer")
//                    self.game.computerPickedFirst = false
//                    seconds = randomTime[randomTime.count.arc4random]
//                    startSeconds = seconds
//                }
//            } else {
//                timer.invalidate()
//                print("Timer deactivated")
//            }
//        }
//    }
    
    // MARK: - Gesture Handlers
    
    // Tap Gesture Handler
    @objc func selectCard(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let location = sender.location(in: cardView)
            
            guard let tappedView = cardView.hitTest(location, with: nil) else { print("No subview was tapped"); return }
            guard let cardIndex = cardView.subviews.index(of: tappedView) else { print("tappedView is not directly in cardView"); return }
            game.selectCard(at: cardIndex)
            makeSelectionVisible(at: cardIndex)
            if game.selectedCards.count == 3 {
                game.checkIfCardsAreSets()
                game.replaceRemovedCardsOnTheField()
                if !game.cardsOnTheField.contains(game.selectedCards[0]) {
                    updateCardView()
                } else {
                    for index in game.indicesOfSelectedCards {
                        game.selectCard(at: index)
                        makeSelectionVisible(at: index)
                    }
                }
                game.resetSelectedCards()
                updateLabels()
            }
        default: break
        }
    }
    
    // Swipe Gesture Handler
    @objc fileprivate func dealThreeMoreCardsWithGesture(sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended: dealThreeMoreCards()
        default: break
        }
    }
    
    // Rotation Gesture Handler
    @objc private func reshuffleCardsOnTheField(sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.reshuffleCardsOnTheField()
            updateCardView()
        default: break
        }
    }
    
}

// MARK: - Extension
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
