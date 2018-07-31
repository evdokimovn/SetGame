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

    @IBOutlet var cards: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func set(button at: Int) {
        let button = cards[at]
        let card = game.cardsInPlay[at]

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
                return [.foregroundColor: color.withAlphaComponent(CGFloat(0.50))]
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
        for index in game.cardsInPlay.indices {
            set(button: index)
        }
    }
}

