//
//  staticValues.swift
//  ChoreApp
//
//  Created by Benjamin Williamson (student LM) on 1/3/19.
//  Copyright © 2019 SeminarGroup. All rights reserved.
//

import Foundation
import UIKit
/*
 File staticValues
 Contains Style class - a list of static variables that represent default values for fonts and colors
 Contains Extensions that contain methods to create default objects
 */
class Styles
{
    //Default fonts; default, small, and big to create text for differently sized object
    static let defaultFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 12)
    static let smallFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 8)
    static let bigFont: UIFont? = UIFont.init(name: "helvetica-neue", size: 18)
    
    //Default colors; first, and second for any object that needs a color of the theme
    static let firstColor: UIColor? = UIColor.white
    static let secondColor: UIColor? = UIColor.black
    
    //Default text colors; standard, and alternate for colors of texts to match the theme
    static let textColor: UIColor? = UIColor.black
    static let alternateTextColor: UIColor? = UIColor.white
    
    //Default background colors; first, and second for backgrounds of objects to match of the theme
    static let firstBackgroundColor: UIColor? = UIColor.white
    static let secondBackgroundColor: UIColor? = UIColor.black
}
enum Condition
{
    case standard
    case big
    case small
    case alternate
    case alternateBig
    case alternateSmall
}
//Create a method applyButtonStyles that allows the creation of a default UIButton
extension UIButton
{
    func applyButtonStyles(type: Condition)
    {
        /*
         Cases 1-3 are standard color buttons, with varying font sizes, default, big, small. Cases are .standard, .big, .small
         Cases 4-6 are alternate color buttons, with varying font sizes, default, big, small. Cases are .alternate, .alternateBig, .alternateSmall
         */
        switch(type)
        {
        case .standard:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case .big:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case .small:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        case .alternate:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case .alternateBig:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.bigFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        case .alternateSmall:
            self.backgroundColor = Styles.secondBackgroundColor
            self.titleLabel?.font = Styles.smallFont
            self.titleLabel?.textColor = Styles.alternateTextColor
            break;
        default:
            self.backgroundColor = Styles.firstBackgroundColor
            self.titleLabel?.font = Styles.defaultFont
            self.titleLabel?.textColor = Styles.textColor
            break;
        }
        
    }
    
}

//Create a method applyLabelStyles that allows the creation of a default UILabel
extension UILabel
{
    func applyLabelStyles(type: Condition)
    {
        /*
         Cases 1-3 are standard color buttons, with varying font sizes, default, big, small. Cases are .standard, .big, .small
         Cases 4-6 are alternate color buttons, with varying font sizes, default, big, small. Cases are .alternate, .alternateBig, .alternateSmall
         */
        switch(type)
        {
        case .standard:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            break;
        case .big:
            self.textColor = Styles.textColor
            self.font = Styles.bigFont
            break;
        case .small:
            self.textColor = Styles.textColor
            self.font = Styles.smallFont
            break;
        case .alternate:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.defaultFont
            break;
        case .alternateBig:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.bigFont
            break;
        case .alternateSmall:
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

//Create a method applyTextFieldStyles that allows the creation of a default UITextField
extension UITextField
{
    func applyTextFieldStyles(type: Condition)
    {
        /*
         Cases 1-3 are standard color buttons, with varying font sizes, default, big, small. Cases are .standard, .big, .small
         Cases 4-6 are alternate color buttons, with varying font sizes, default, big, small. Cases are .alternate, .alternateBig, .alternateSmall
         */
        switch(type)
        {
        case .standard:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        case .big:
            self.textColor = Styles.textColor
            self.font = Styles.bigFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        case .small:
            self.textColor = Styles.textColor
            self.font = Styles.smallFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        case .alternate:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.defaultFont
            self.backgroundColor = Styles.secondBackgroundColor
            break;
        case .alternateBig:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.bigFont
            self.backgroundColor = Styles.secondBackgroundColor
            break;
        case .alternateSmall:
            self.textColor = Styles.alternateTextColor
            self.font = Styles.smallFont
            self.backgroundColor = Styles.secondBackgroundColor
            break;
        default:
            self.textColor = Styles.textColor
            self.font = Styles.defaultFont
            self.backgroundColor = Styles.firstBackgroundColor
            break;
        }
    }
}
