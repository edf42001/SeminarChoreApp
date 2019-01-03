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
    static let textColor: UIColor? = UIColor.init(named: "black")
    static let backgroundColor: UIColor? = UIColor.init(named: "white")
    
    
    static func setUpDefaultButton(button: UIButton)
    {
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = defaultFont
        button.titleLabel?.textColor = textColor
    }
    
    static func setUpDefaultLabel(label: UILabel)
    {
        label.textColor = textColor
        label.font = defaultFont
    }
    
    static func setUpDefaultTextField(textField: UITextField)
    {
        textField.textColor = textColor
        textField.font = defaultFont
        textField.backgroundColor = backgroundColor
    }
    
}
