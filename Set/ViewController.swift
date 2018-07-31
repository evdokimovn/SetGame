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
    @IBOutlet weak var dealCardsButton: UIButton!

    @IBAction func dealMoreCards(_ sender: UIButton) {
        if cardsForButtons.count == 24 {
            return
        }
        game.dealCards()
        setupGame()
    }

    @IBAction func startNewGame(_ sender: UIButton) {
        newGameButton.isHidden = true
        dealCardsButton.isHidden = false
        selected = []
        cardsForButtons = [:]
        game = Set()
        setupGame()
    }


    func finishGame() {
        newGameButton.isHidden = false
        dealCardsButton.isHidden = true
        for button in cardButtons {
            button.isHidden = true
        }
    }

    @IBAction func selectCard(_ sender: UIButton) {
        if selected.count == 3 {
            for button in selected {
                button.layer.borderWidth = 0.0
            }
            selected = []
            if !game.doFormSet() {
                markAs(selected: sender)
            } else {
                game.replace()
                setupGame()
            }
        } else {
            if selected.contains(sender) {
                let buttonIndex = selected.index(of: sender)!
                selected.remove(at: buttonIndex)
                sender.layer.borderWidth = 0.0
                sender.layer.borderColor = UIColor.blue.cgColor
            } else {
                markAs(selected: sender)
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
            }
        }
        if game.cardsInPlay.count == 0 {
            finishGame()
        }
    }

    private func markAs(selected button: UIButton) {
        selected.append(button)
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.blue.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.isHidden = true
        setupGame()
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

    private func setupGame() {
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
    }
}

