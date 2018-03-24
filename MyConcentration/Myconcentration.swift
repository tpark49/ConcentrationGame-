//
//  Myconcentration.swift
//  MyConcentration
//
//  Created by Yu-Ting Chen on 3/19/18.
//  Copyright © 2018 Tony Park. All rights reserved.
//

import Foundation


class Myconcentration
{
    //array of cards
    var cards = [Card]()
    
    
    //function to choose card
    func chooseCard(index: Int){
        
        var indexOfOne:Int?
    
        
        //check what the value of indexOfOne would be
        for myIndex in cards.indices{
            if cards[myIndex].faceUp  == true{
                if indexOfOne == nil, myIndex != index{
                    indexOfOne = myIndex
                }else{
                    indexOfOne = nil
                }
            }
        }
        
        //if there is one card up
        if indexOfOne != nil{
            if cards[index] == cards[indexOfOne!]{
                cards[index].isMatched = true
                cards[indexOfOne!].isMatched = true
            }
        //if there is either two faceup or two facedown
        }else{
            for faceDown in cards.indices{
                cards[faceDown].faceUp = false
            }
        }
        cards[index].faceUp = true

    }

//init - arguemtn? - initialiize the array of cards
    init(numberOfPairsofCards: Int){
        var randomDeck = [Card]()
        for _ in 1...numberOfPairsofCards{
            let card = Card()
            randomDeck += [card, card]
        }
        
        for _ in 1...numberOfPairsofCards*2{
            let randInt = Int(arc4random_uniform(UInt32(randomDeck.count)))
            cards += [randomDeck[randInt]]
            randomDeck.remove(at: randInt)
        }
        
    }
    
        
    
}
    
        



