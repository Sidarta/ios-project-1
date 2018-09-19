//
//  Concentration.swift
//  Concentration
//
//  Created by Sidarta Fernandes on 9/12/18.
//  Copyright © 2018 Sidarta Fernandes. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var arrayOfCards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            
            return arrayOfCards.indices.filter { arrayOfCards[$0].isFaceUp }.oneAndOnly //using closure and protocol extension
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
//            var foundIndex: Int?
//            for index in arrayOfCards.indices {
//                if(arrayOfCards[index].isFaceUp) {
//                    if(foundIndex == nil){
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//
//            return foundIndex
        }
        set {
            for index in arrayOfCards.indices {
                arrayOfCards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    
    var score = 0.0
    
    //no need to store the entire card here, since each card is ID'd by an index
    private var alreadyRevealedCardIndexes = [Int]()
    
    mutating func chooseCard(at index:Int){
        
        assert(arrayOfCards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen card was not in the cards")
        
        if !arrayOfCards[index].isMatched {
            
            //correcting flip count to not increase on a card already face up
            if(!arrayOfCards[index].isFaceUp){
                flipCount += 1
            }
            
            arrayOfCards[index].lastTouchTimeStamp = Date()
            
            if let otherCardIndex = indexOfOneAndOnlyFaceUpCard, otherCardIndex != index {
                //taping when a card is already up
                
                let timePenalty = arrayOfCards[index].lastTouchTimeStamp.timeIntervalSince(arrayOfCards[otherCardIndex].lastTouchTimeStamp)
                
                if arrayOfCards[otherCardIndex] == arrayOfCards[index] {
                    //cards matched
                    arrayOfCards[otherCardIndex].isMatched = true
                    arrayOfCards[index].isMatched = true
                    
                    //score two points for a match
                    score += (10.00/timePenalty) // TODO: stablish a constant for score points so its esier to change the scale of the score
                } else {
                    //cards did not match, reduce score
                    if alreadyRevealedCardIndexes.contains(index){
                        score -= (1.0 * timePenalty)
                    } else {
                        alreadyRevealedCardIndexes.append(index)
                    }
                    if alreadyRevealedCardIndexes.contains(otherCardIndex){
                        score -= (1.0 * timePenalty)
                    } else {
                        alreadyRevealedCardIndexes.append(otherCardIndex)
                    }
                    
                    print(arrayOfCards[index].lastTouchTimeStamp.timeIntervalSince(arrayOfCards[otherCardIndex].lastTouchTimeStamp))
                    
                }
                arrayOfCards[index].isFaceUp = true
            } else {
                //tapping when no cards are up or two cards are up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): negative number of cards")
        addCards(numberOfPairsOfCards : numberOfPairsOfCards)
    }
    
    //did this in case new game was inside the model
    private mutating func addCards(numberOfPairsOfCards: Int){
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            arrayOfCards += [card, card] //because its value not reference (copyes)
        }
        
        //shuffle cards - O(2n) - iterating two times over the array
        let totalNumberOfCards = arrayOfCards.count
        var shuffledArray = [Card]()
        for _ in 0..<totalNumberOfCards{
            let randomIndex = Int(arc4random_uniform(UInt32(arrayOfCards.count)))
            let card = arrayOfCards.remove(at: randomIndex)
            shuffledArray += [card]
        }
        arrayOfCards = shuffledArray
        
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
