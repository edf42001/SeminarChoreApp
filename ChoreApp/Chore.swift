//
//  Chore.swift
//  ChoreApp
//
//  Created by Ethan Frank (student LM) on 12/11/18.
//  Copyright © 2018 SeminarGroup. All rights reserved.
//

import Foundation

class Chore{
    let id:String
    let name:String
    let asigneeID:String
    
    init(id:String, name:String, asigneeID:String){
        self.id = id
        self.name = name
        self.asigneeID = asigneeID
    }
}

