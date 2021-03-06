//
//  ViewController.swift
//  MyConcentration
//
//  Created by Tony Park on 3/19/18.
//  Copyright © 2018 Tony Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var mygame: Myconcentration = Myconcentration(numberOfPairsofCards:self.cardButton.count/2)
    
    //flipcount variable
    private(set) var flipCount = 0
    
    //score variable
    var scorePoints = 0
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    var scoreLib = [Card:Bool]()
    
    //doesn't work
    private func checkScore(){
        for index in cardButton.indices{
            let card = mygame.cards[index]
            
            if card.faceUp{
                //if the card is not in the library
                if scoreLib[card] == nil{
                    if card.isMatched == true{
                        
                        scorePoints+=1
                    }
                    
                    scoreLib[card] = true
                }
            
                //if the card is already in the library
                else if scoreLib[card] == true{
                    if card.isMatched == false{
                        scorePoints-=1
                    }
                }
            
                //skip the card if matched and seen before
                if card.isMatched == true, scoreLib[card]==true{
                    continue
                }
            
            }
        scoreLabel.text = "Score:" + String(scorePoints)
        }}
    
    //function to update score
    private func updateScore(at index: Int){
        //find out if there is only one card faced up
        var oneCardUp = false
        var oneCardIndex = 0
        for cardIndex in cardButton.indices{
            if mygame.cards[cardIndex].faceUp == true, oneCardUp == false, index != cardIndex{
                oneCardUp = true
                oneCardIndex = cardIndex
            }
        }
        
        var theOtherPair: Card?
        //if only onecardup istrue
        if oneCardUp == true{
            if mygame.cards[index].isMatched == false{
                for cardIndex in cardButton.indices{
                    if mygame.cards[cardIndex] == mygame.cards[oneCardIndex], cardIndex != oneCardIndex {
                        theOtherPair = mygame.cards[cardIndex]
                    }}
                if theOtherPair != nil{
                    scorePoints-=1
                }
            }
        }
        if scoreLib[mygame.cards[index]] == nil{
            scoreLib[mygame.cards[index]] = true
        }
        
        //if cards have matched
        if mygame.cards[index].isMatched == true{
            scorePoints += 2
        }
        scoreLabel.text = "Score:" + String(scorePoints)
    }

    
        
    
    //a function to start a new game
    @IBAction private func newGame(_ sender: UIButton) {
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
            mygame.cards[array[randInt]] = mygame.cards[index]
            array.remove(at: randInt)
            
            let randInt_2 = Int(arc4random_uniform(UInt32(array.count)))
            mygame.cards[array[randInt_2]] = mygame.cards[index]
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
        scoreLabel.text = "Score:" + String(scorePoints)
        
        //reset score library 
        for (keyIndex, _) in scoreLib{
            scoreLib[keyIndex] = nil
        }
    }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButton: [UIButton]!

    
    @IBAction private func touchButton(_ sender: UIButton) {
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
    
    private func updateView(){
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
    
    private var emojiLibrary = [0:["😇","😉","🤓","🙄","😡","😍","🤑","😋"],
                        1:["🐶","🐷","🐸","🐴","🦁","🐰","🐙"],
                        2:["🌧","⛈","🌨","☀️","☔️","🌝","☃️","💫"]]

    private var emojiChoice = ["😇","😉","🤓","🙄","😡","😍","🤑","😋"]
    private var emojiDict = [Card:String]()
    

    private func setTheme(){
        let emojiIndex = Int(arc4random_uniform(UInt32(emojiLibrary.keys.count)))
        if (emojiLibrary[emojiIndex] != nil){
            emojiChoice = emojiLibrary[emojiIndex]!
        }else{
            print("index not found in emoji library")
        }
    }
    
    private func emoji(for card: Card) -> String {
        
        if emojiDict[card] == nil, emojiChoice.count>0{
            emojiDict[card] = emojiChoice.remove(at: emojiChoice.count.arc4random)
        }
        return emojiDict[card] ?? "?"
    }
}


extension Int{
    var arc4random: Int{
        if self>0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self<0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
        

    }
}

