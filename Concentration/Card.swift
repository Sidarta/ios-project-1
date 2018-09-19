//
//  Card.swift
//  Concentration
//
//  Created by Sidarta Fernandes on 9/12/18.
//  Copyright © 2018 Sidarta Fernandes. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var lastTouchTimeStamp = Date()
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var hashValue: Int { return identifier }
}

