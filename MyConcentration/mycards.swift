//
//  mycards.swift
//  MyConcentration
//
//  Created by Yu-Ting Chen on 3/19/18.
//  Copyright © 2018 Tony Park. All rights reserved.
//

import Foundation

struct Card
{
    //face up or down
    var faceUp = false
    
    //matched or not
    var isMatched = false
    
    //identifier 
    var identifier: Int
    
    static var identifier_helper = 0
    
    //unique identifier to determine if theres a match
    static func getUniqueIdentifier() -> Int{
        identifier_helper+=1
        return identifier_helper
    }
    
    //init with - arguemnt? - with unique identifier
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }

}
