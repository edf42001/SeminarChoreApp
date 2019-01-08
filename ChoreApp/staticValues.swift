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
    static let firstColor: UIColor? = UIColor.white
    static let secondColor: UIColor? = UIColor.black
    static let textColor: UIColor? = UIColor.black
    static let alternateTextColor: UIColor? = UIColor.white
    static let firstBackgroundColor: UIColor? = UIColor.white
    static let secondBackgroundColor: UIColor? = UIColor.black
    
    static func setUpDefaultLabel(label: UILabel)
    {
        label.textColor = textColor
        label.font = defaultFont
    }
    
    static func setUpDefaultTextField(textField: UITextField)
    {
        
        textField.textColor = textColor
        textField.font = defaultFont
        textField.backgroundColor = firstBackgroundColor
    }
    
}
extension UIButton
{
    func applyButtonStyles(type: Int)
    {
        switch(type)
        {
        case 1:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 2:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 3:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 4:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 5:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 6:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 7:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case 8:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case 9:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case 10:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case 11:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case 12:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        default:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        }
        
    }
    
}
extension UILabel
{
    func applyLabelStyles(type: Int)
    {
        switch(type)
        {
        case 1:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            break;
        case 2:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.defaultFont
            break;
        case 3:
            self.textColor = Styles.textColor
            self.font = Styles.bigFont
            break;
        case 4:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.bigFont
            break;
        case 1:
            self.textColor = Styles.textColor
            self.font = Styles.smallFont
            break;
        case 2:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.smallFont
            break;
        default:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            break;
            
        }
    }
}
extension UITextField
{
    func applyTextFieldStyles(type: Int)
    {
        switch(type)
        {
        case 1:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        case 2:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        default:
            break;
        }
    }
}
