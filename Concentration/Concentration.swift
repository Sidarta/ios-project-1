//
//  Concentration.swift
//  Concentration
//
//  Created by Sidarta Fernandes on 9/12/18.
//  Copyright © 2018 Sidarta Fernandes. All rights reserved.
//

import Foundation

class Concentration {
    var arrayOfCards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index:Int){
        if !arrayOfCards[index].isMatched {
            if let otherCardIndex = indexOfOneAndOnlyFaceUpCard, otherCardIndex != index {
                //taping when a card is already up
                if arrayOfCards[otherCardIndex].identifier == arrayOfCards[index].identifier {
                    //cards matched
                    arrayOfCards[otherCardIndex].isMatched = true
                    arrayOfCards[index].isMatched = true
                }
                arrayOfCards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //tapping when no cards are up or two cards are up
                for flipDownIndex in arrayOfCards.indices {
                    arrayOfCards[flipDownIndex].isFaceUp = false
                }
                arrayOfCards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            arrayOfCards += [card, card] //because its value not reference (copyes)
        }
        
        // TODO: shuffle cards
    }
}
