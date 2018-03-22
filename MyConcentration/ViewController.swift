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
    
    
    //score variable
    var scorePoints = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scoreLib = [Int:Bool]()
    func checkScore(){
        for index in cardButton.indices{
            let card = mygame.cards[index]
            
            if card.faceUp{
                //if the card is not in the library
                if scoreLib[card.identifier] == nil{
                    if card.isMatched == true{
                        scorePoints+=1
                    }
                    scoreLib[card.identifier] = true
                }
            
                //if the card is already in the library
                else if scoreLib[card.identifier] == true{
                    if card.isMatched == false{
                        scorePoints-=1
                    }
                }
            
                //skip the card if matched and seen before
                if card.isMatched == true, scoreLib[card.identifier]==true{
                    continue
                }
            
            }
        scoreLabel.text = "Score:" + String(scorePoints)
        }}
    
    
    func updateScore(at index: Int){
        //find out if there is only one card faced up
        var oneCardUp = false
        var oneCardIndex = 0
        for cardIndex in cardButton.indices{
            if mygame.cards[cardIndex].faceUp == true, oneCardUp == false, index != cardIndex{
                oneCardUp = true
                oneCardIndex = cardIndex
            }
        }
        var theOtherPair = 0
        var theOtherPair_1 = 0
        
        //if only onecardup istrue
        if oneCardUp == true{
            if mygame.cards[index].isMatched == false{
                if scoreLib[index] == nil{
                    scoreLib[index] = true
                }
                for cardIndex in cardButton.indices{
                    if mygame.cards[cardIndex].identifier == mygame.cards[oneCardIndex].identifier {
                        theOtherPair = cardIndex
                    }}
                if scoreLib[theOtherPair] == true{
                    scorePoints-=1
                }
            }
        }
        //if cards have matched
        if mygame.cards[index].isMatched == true{
            scorePoints += 2
        }
        scoreLabel.text = "Score:" + String(scorePoints)
    }

    
        
    
    
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
        

        //clear dictionary
        for (keyIndex, _) in emojiDict{
            emojiDict[keyIndex] = nil
        }
        
        //set New Theme
        setTheme()
        
        //update view
        updateView()
        
        //reset score
        scorePoints = 0
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
            
            //update score
            updateScore(at: cardNumber)
            
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
    
    var emojiLibrary = [0:["😇","😉","🤓","🙄","😡","😍","🤑","😋"],
                        1:["🐶","🐷","🐸","🐴","🦁","🐰","🐙"],
                        2:["🌧","⛈","🌨","☀️","☔️","🌝","☃️","💫"]]

    var emojiChoice = ["😇","😉","🤓","🙄","😡","😍","🤑","😋"]
    var emojiDict = [Int:String]()
    
    
    func setTheme(){
        let emojiIndex = Int(arc4random_uniform(UInt32(emojiLibrary.keys.count)))
        if (emojiLibrary[emojiIndex] != nil){
            emojiChoice = emojiLibrary[emojiIndex]!
        }else{
            print("index not found in emoji library")
        }
    }
    
    func emoji(for card: Card) -> String {
        
        if emojiDict[card.identifier] == nil, emojiChoice.count>0{
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoice.count)))
            emojiDict[card.identifier] = emojiChoice.remove(at: randomIndex)
        }
        return emojiDict[card.identifier] ?? "?"
    }
}




