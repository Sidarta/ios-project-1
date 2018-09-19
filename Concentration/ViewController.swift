//
//  ViewController.swift
//  Concentration
//
//  Created by Sidarta Fernandes on 9/11/18.
//  Copyright © 2018 Sidarta Fernandes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtonsArray.count + 1) / 2
    }
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCount()
        }
    }
    
    @IBOutlet var cardButtonsArray: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //pre defined set of themes - to add a new theme, just add a new array with a theme here (1 line)
    var emojiThemes = [["😋","😝","😎","🤩", "🙃", "😇", "😍", "😱"],
                       ["🍫","🍿","🍩","🍪", "🎂", "🍨", "🥧", "🍭"],
                       ["🎾","🏀","🏉","🎱", "⚽️", "🏓", "🏸", "🏒"],
                       ["🇧🇷","🇧🇴","🇧🇪","🇦🇿", "🇨🇦", "🇨🇿", "🇫🇮", "🇩🇪"]]
    
    var backgroundColorForThemes = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                                    #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),
                                    #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                    #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
    
    var cardBackgroundColorForThemes = [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),
                                        #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),
                                        #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                                        #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]

    var randomThemeIndex = 0
    
    var emojiChoices = [String]()
    
    override func viewDidLoad() {
        //when app starts we need to define a random theme for the first game
        defineRandomTheme()
    }
    
    //define emoji choices to be one of the random themes
    private func defineRandomTheme(){
        randomThemeIndex = emojiThemes.count.arc4random
        emojiChoices = emojiThemes[randomThemeIndex]
        
        //defining card backgrounds
        for button in cardButtonsArray {
            button.backgroundColor = cardBackgroundColorForThemes[randomThemeIndex]
        }
        
        self.view.backgroundColor = backgroundColorForThemes[randomThemeIndex]
    }
    
    @IBAction func tapCard(_ sender: UIButton) {
        if let cardNumber = cardButtonsArray.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Card was not in the array")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtonsArray.indices {
            let card = game.arrayOfCards[index]
            let button = cardButtonsArray[index]
            if card.isFaceUp {
                //flip front
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                //flip back
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackgroundColorForThemes[randomThemeIndex]
            }
        }
        updateFlipCount()
        scoreLabel.text = "Score: \(game.score.rounded())"
    }
    
    private func updateFlipCount(){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.black
        ]
        let attributedString = NSAttributedString(string: "Flip count: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    var emoji = [Card:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.count.arc4random
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card] ?? "?"
    }
    
    
    @IBAction func tapNewGame(_ sender: UIButton) {
        //create a new game by creating a new instance for the game class
        game = Concentration(numberOfPairsOfCards: (cardButtonsArray.count + 1) / 2)
        
        //define a new theme for a new game
        defineRandomTheme()
        
        //update UI
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if(self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        } else if (self < 0){
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
