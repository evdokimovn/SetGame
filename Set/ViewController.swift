//
//  ViewController.swift
//  Set
//
//  Created by Dbrain on 22/07/2018.
//  Copyright © 2018 Nikita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()
    var selected: [UIButton] = []
    var cardsForButtons: [UIButton: Card] = [:]

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    // “Deal 3 More Cards” button (as per the rules of Set).
    @IBOutlet weak var dealCardsButton: UIButton!

    @IBAction func dealMoreCards(_ sender: UIButton) {
        if selected.count == 3 && game.doFormSet() {
            for button in selected {
                button.layer.borderWidth = 0.0
            }
            selected = []
            game.replace()
        } else {
            if cardsForButtons.count == 24 {
                return
            }
            game.dealCards()
        }

        updateUI()
    }

    @IBAction func startNewGame(_ sender: UIButton) {
        newGameButton.isHidden = true
        dealCardsButton.isHidden = false
        selected = []
        cardsForButtons = [:]
        game = Set()
        updateUI()
    }


    func finishGame() {
        newGameButton.isHidden = false
        dealCardsButton.isHidden = true
        for button in cardButtons {
            button.isHidden = true
        }
    }


    // Allow the user to select cards to try to match as a Set by touching on the cards
    @IBAction func selectCard(_ sender: UIButton) {
        //When any card is chosen
        if selected.count == 3 {
            for button in selected {
                button.layer.borderWidth = 0.0
            }
            selected = []
            //and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and then select the chosen card.
            if !game.doFormSet() {
                markAs(selected: sender)
                // and there are already 3 matching Set cards selected, replace those 3 matching Set cards with new ones from the deck
            } else {
                game.replace()
            }
        } else {
            markAs(selected: sender)
        }

        // After 3 cards have been selected, you must indicate whether those 3 cards are a match or a mismatch (per Set rules).
        if selected.count == 3 {
            for button in selected {
                let card = cardsForButtons[button]!
                game.select(card: card)
            }
            if game.doFormSet() {
                for button in selected {
                    button.layer.borderColor = UIColor.yellow.cgColor
                }
            }
        }
        updateUI()
    }

    private func markAs(selected button: UIButton) {
        if selected.contains(button) {
            let buttonIndex = selected.index(of: button)!
            selected.remove(at: buttonIndex)
            button.layer.borderWidth = 0.0
            button.layer.borderColor = UIColor.blue.cgColor }
        else {
            selected.append(button)
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.isHidden = true
        updateUI()
    }

    private func setForButton(card: Card) {
        for button in cardButtons {
            if cardsForButtons[button] == nil {
                cardsForButtons[button] = card
                return
            }
        }
    }

    func drawCard(on button: UIButton) {
        let card = cardsForButtons[button]!
        let symbol: String = {
            switch card.symbol {
            case .Diamond:
                return "▲"
            case .Oval:
                return "●"
            case .Squiggle:
                return "■"
            }
        }()

        let color: UIColor = {
            switch card.color {
            case .Red:
                return UIColor.red
            case .Green:
                return UIColor.green
            case .Blue:
                return UIColor.blue
            }
        }()

        let shading: [NSAttributedStringKey: Any] = {
            switch card.shading {
            case .Solid:
                return [.foregroundColor: color]
            case .Striped:
                return [.foregroundColor: color.withAlphaComponent(CGFloat(0.25))]
            case .Open:
                return [.foregroundColor: color,
                        .strokeWidth: 15]
            }
        }()

        let cardAttributedString: NSAttributedString = {
            switch card.number {
            case .One:
                return NSAttributedString(string: symbol, attributes: shading)
            case .Two:
                return NSAttributedString(string: symbol + symbol, attributes: shading)
            case .Three:
                return NSAttributedString(string: symbol + symbol + symbol, attributes: shading)
            }
        }()

        button.setAttributedTitle(cardAttributedString, for: .normal)
    }

    private func updateUI() {
        var cards: [Card] = []
        for (button, card) in cardsForButtons {
            if !game.cardsInPlay.contains(card) {
                cardsForButtons.removeValue(forKey: button)
            } else {
                cards.append(card)
            }
        }

        for card in game.cardsInPlay {
            if !cards.contains(card) {
                setForButton(card: card)
            }
        }

        for button in cardButtons {
            if cardsForButtons[button] == nil {
                button.isHidden = true
            } else {
                drawCard(on: button)
                button.isHidden = false
            }
        }

        if (game.hasMoreCards() && cardsForButtons.count < 24) || (game.doFormSet() && selected.count == 3) {
            dealCardsButton.isHidden = false
        } else {
            dealCardsButton.isHidden = true
        }

        if game.cardsInPlay.count == 0 {
            finishGame()
        }
    }
}

