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
    
    static let choreNames = ["Make the bed", "Walk the dog", "Clean the house", "Do the dishes", "Do the laundry", "Clean your room", "Take out the trash", "Feed the pet", "Mow the lawn"]
    static let choreImages = ["Bed.jpeg", "Dog.png", "House.png", "Dishes.png", "Laundry.png", "Room.png", "Trash.png", "Pet.png", "Lawn.png", "Custom.png"]
    
    init(id:String, name:String, asigneeID:String, choreType:ChoreType){
        self.id = id
        self.name = name
        self.asigneeID = asigneeID
        self.choreType = choreType
    }
    
    static func getChoreImage(choreType: ChoreType) -> UIImage? {
        let imageName = choreImages[choreType.rawValue]
        let image = UIImage(named: imageName)
        if image == nil {
            return UIImage(named: "Custom.png")
        }
        return image
    }

}

enum ChoreType: Int {
    case Bed = 0, Dog, House, Dishes, Laundry, Room, Trash, Pet, Lawn, Custom, total
}






