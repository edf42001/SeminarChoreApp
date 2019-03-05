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
    
    //Default ViewController background color
    static let backgroundColor: UIColor? = UIColorFromRGB(0x373c3c)
    
    //Default tab background color
    //Up for future debate
    static let tabColor: UIColor? = UIColor.black
    
    //Default Black/greyish background: 0x373C3C
    //Logo grey color: 0xD3E1DF
    //Logo red: 0xEE5551
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

enum ButtonStyle {
    case standard
}

//Create a method applyButtonStyles that allows the creation of a default UIButton
extension UIButton {
    func applyButtonStyles(type: ButtonStyle){
        switch type{
        case .standard:
            self.backgroundColor = UIColorFromRGB(0xD3E1DF)
            self.titleLabel?.font = Styles.defaultFont
            self.setTitleColor(Styles.textColor, for: .normal)
            self.layer.cornerRadius = 15
            self.layer.borderWidth = 5
            self.layer.borderColor = UIColorFromRGB(0xEE5551).cgColor
            break
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
        }
    }
}

func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

@IBDesignable
class ButtonExtension: UIButton {
    //MARK: PROPERTIES
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    //MARK: Initializers
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

@IBDesignable
class ViewExtension: UIView {
    //MARK: PROPERTIES
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 1.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 1.0
    }
    
    func configure() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
}
