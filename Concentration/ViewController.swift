//
//  ViewController.swift
//  Concentration
//
//  Created by Sidarta Fernandes on 9/11/18.
//  Copyright © 2018 Sidarta Fernandes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtonsArray.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtonsArray: [UIButton]!
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip count: \(flipCount)"
        }
    }
    


    @IBAction func tapCard(_ sender: UIButton) {
        flipCount += 1

        if let cardNumber = cardButtonsArray.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Card was not in the array")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtonsArray.indices {
            let card = game.arrayOfCards[index]
            let button = cardButtonsArray[index]
            if card.isFaceUp {
                //flip front
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                //flip back
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    .gitignore
    .gitignore
    var emojiChoices = ["👻","🎒","🧢","☠️", "🎩", "🐌", "🌚", "🥐"]
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
        
    }
}

