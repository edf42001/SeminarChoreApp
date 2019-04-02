//
//  Chore.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/11/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import Foundation
import UIKit

class Chore{
    let id:String
    let name:String
    let asigneeID:String
    let choreType:ChoreType
    
    static let choreNames = ["Make the Bed", "Walk the Dog", "Clean the House"]
    static let choreImages = ["Bed.png", "Dog.png", "House.png"]
    
    init(id:String, name:String, asigneeID:String, choreType:ChoreType){
        self.id = id
        self.name = name
        self.asigneeID = asigneeID
        self.choreType = choreType
    }
    
    static func getChoreImage(choreType: ChoreType) -> UIImage? {
        let imageName = choreImages[choreType.rawValue]
        let image = UIImage(named: imageName)
        return image
    }
    
}

enum ChoreType: Int {
    case Bed = 0, Dog, House, Custom, total
}




