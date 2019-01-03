//
//  staticValues.swift
//  ChoreApp
//
//  Created by Benjamin Williamson (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import Foundation
import UIKit
class Styles
{
    static let defaultFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 12)
    static let smallFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 8)
    static let bigFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 18)
    static let firstColor: UIColor? = UIColor.init(named: "white")
    static let secondColor: UIColor? = UIColor.init(named: "black")
    
    static func defaultButton(button: UIButton)
    {
        button.backgroundColor = firstColor
        button.titleLabel?.font = defaultFont
        button.titleLabel?.textColor = secondColor
        
    }
    
    static func defaultLabel(label: UILabel)
    {
        label.textColor = secondColor
        label.font = defaultFont
    }
}
