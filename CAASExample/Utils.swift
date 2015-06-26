/*
********************************************************************
* Licensed Materials - Property of IBM                             *
*                                                                  *
* Copyright IBM Corp. 2015 All rights reserved.                    *
*                                                                  *
* US Government Users Restricted Rights - Use, duplication or      *
* disclosure restricted by GSA ADP Schedule Contract with          *
* IBM Corp.                                                        *
*                                                                  *
* DISCLAIMER OF WARRANTIES. The following [enclosed] code is       *
* sample code created by IBM Corporation. This sample code is      *
* not part of any standard or IBM product and is provided to you   *
* solely for the purpose of assisting you in the development of    *
* your applications. The code is provided "AS IS", without         *
* warranty of any kind. IBM shall not be liable for any damages    *
* arising out of your use of the sample code, even if they have    *
* been advised of the possibility of such damages.                 *
********************************************************************
*/


import UIKit


func maximum<T:RawRepresentable where T.RawValue:SignedIntegerType > (enumType:T.Type) -> T.RawValue {
    var max: T.RawValue = 0
    while let _ = enumType(rawValue: ++max) {}
    return max
    
}

class Utils {
    
    /// Update the font of the UILabel within the range 15/22
    class func updateBodyTextStyle(label:UILabel) {
        
        var font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        if font.pointSize > 22 {
            font = font.fontWithSize(22)
        }
        if font.pointSize < 15 {
            font = font.fontWithSize(15)
        }
        
        label.font = font;
        
    }
    
    /// Update the font of the UIButton within the range 15/22
    class func updateBodyTextStyle(button:UIButton) {
        
        var font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        if font.pointSize > 22 {
            font = font.fontWithSize(22)
        }
        if font.pointSize < 15 {
            font = font.fontWithSize(15)
        }
        
        button.titleLabel?.font = font;
        
    }
    

}