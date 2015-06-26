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

class HairLine: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var lineColor:UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 1/UIScreen.mainScreen().scale)
        CGContextTranslateCTM(context, 0, 0.5)
        
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        
        
        CGContextMoveToPoint(context, 0, self.bounds.size.height/2);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height/2);
        CGContextStrokePath(context);
    }

}
