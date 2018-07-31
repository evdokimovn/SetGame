//
//  Set.swift
//  Set
//
//  Created by Dbrain on 22/07/2018.
//  Copyright © 2018 Nikita. All rights reserved.
//

import Foundation



class Set {
    private var cards: [Card]
    private(set) var cardsInPlay: [Card]
    private(set) var selected: [Card]


    func select(card at: Int) -> Bool {
        if at < 0 || at >= cardsInPlay.count {
            return false
        }

        let card = cardsInPlay[at]
        if selected.count == 3 {
            selected = []
        }

        selected.append(card)
        return true
    }

    private func doFormSet() -> Bool {
        if selected.count != 3 {
            return false
        }

        let card1 = selected[0]
        let card2 = selected[1]
        let card3 = selected[2]



        if (card1.number == card2.number && card3.number != card2.number) ||
            (card1.number == card3.number && card2.number != card3.number) ||
            (card2.number == card3.number && card1.number != card2.number) {
            return false
        }


        if (card1.color == card2.color && card3.color != card2.color) ||
            (card1.color == card3.color && card2.color != card3.color) ||
            (card2.color == card3.color && card1.color != card2.color) {
            return false
        }


        if (card1.shading == card2.shading && card3.shading != card2.shading) ||
            (card1.shading == card3.shading && card2.shading != card3.shading) ||
            (card2.shading == card3.shading && card1.shading != card2.shading) {
            return false
        }

        if (card1.symbol == card2.symbol && card3.symbol != card2.symbol) ||
            (card1.symbol == card3.symbol && card2.symbol != card3.symbol) ||
            (card2.symbol == card3.symbol && card1.symbol != card2.symbol) {
            return false
        }

        return true
    }

    init() {
        self.cards = Array()
        self.cards.reserveCapacity(81)
        for color in Card.Color.allValues {
            for number in Card.Number.allValues {
                for shading in Card.Shading.allValues {
                    for symbol in Card.Symbol.allValues {
                        cards.append(Card(color, number, shading, symbol))
                    }
                }
            }
        }
        self.cards.shuffle()
        cardsInPlay = Array(cards.prefix(12))
        selected = Array()
    }
}


extension Array {
    mutating func shuffle() {
        var last = self.count - 1
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            self.swapAt(last, rand)
            last -= 1
        }
    }
}
