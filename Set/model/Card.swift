//
//  Card.swift
//  Set
//
//  Created by Dbrain on 22/07/2018.
//  Copyright © 2018 Nikita. All rights reserved.
//

import Foundation


struct Card {
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color


    enum Number: String {
        case One, Two, Three

        static let allValues = [One, Two, Three]
    }

    enum Symbol: String {
        case Diamond, Squiggle, Oval

        static let allValues = [Diamond, Squiggle, Oval]
    }

    enum Shading: String {
        case Solid, Striped, Open

        static let allValues = [Solid, Striped, Open]
    }

    enum Color: String {
        case Red, Green, Blue

        static let allValues = [Red, Green, Blue]
    }


    init(_ color: Color, _ number: Number, _ shading: Shading, _ symbol: Symbol) {
        self.number = number
        self.color = color
        self.shading = shading
        self.symbol = symbol
    }
}
