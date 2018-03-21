//
//  ViewController.swift
//  MyConcentration
//
//  Created by Tony Park on 3/19/18.
//  Copyright © 2018 Tony Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var mygame: Myconcentration = Myconcentration(numberOfPairsofCards:self.cardButton.count/2)
    
    //flipcount variable
    var flipCount = 0
    
    @IBAction func newGame(_ sender: UIButton) {
        //flip over all the cards
        var array = [Int]()
        for index in 0..<cardButton.count{
            array.append(index)
        }
        
        for index in cardButton.indices{
            mygame.cards[index].faceUp = false
            mygame.cards[index].isMatched = false
        }
    
        //unique emojies by adding identifiers
        for index in 1...cardButton.count/2{
            let randInt = Int(arc4random_uniform(UInt32(array.count)))
            mygame.cards[array[randInt]].identifier = index
            array.remove(at: randInt)
            
            let randInt_2 = Int(arc4random_uniform(UInt32(array.count)))
            mygame.cards[array[randInt_2]].identifier = index
            array.remove(at: randInt_2)
        
            
        }
        //set count to 0 again
        flipCount = 0
        flipCountLabel.text = "Count:"+String(flipCount)
        
        //update view
        updateView()
        
        print(emojiDict)
    }
    
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButton: [UIButton]!

    
    @IBAction func touchButton(_ sender: UIButton) {
        //user chooses card - at certain index
        if let cardNumber = cardButton.index(of: sender){
            //function to choose card
            mygame.chooseCard(index: cardNumber)
            
            //update flipcount
            flipCount+=1
            flipCountLabel.text = "Count:" + String(flipCount)
            
            //update the view setting
            updateView()
            
        }
        
    }
    
    func updateView(){
        for cardIndex in cardButton.indices{
            let Button = cardButton[cardIndex]
            let MyCard = mygame.cards[cardIndex]
            
            if MyCard.faceUp{
                Button.setTitle(emoji(for: MyCard), for: UIControlState.normal)
                Button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }else{
                Button.setTitle("", for: UIControlState.normal)
                Button.backgroundColor = MyCard.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0):#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                
            }
            
        }
        
    }
    
    var emojiChoices = ["😇","😉","🤓","🙄","😡","😍","🤑","😋"]
    var emojiDict = [Int:String]()
    
    func emoji(for card: Card) -> String {
        
        if emojiDict[card.identifier] == nil, emojiChoices.count>0{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emojiDict[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emojiDict[card.identifier] ?? "?"
    }
}




