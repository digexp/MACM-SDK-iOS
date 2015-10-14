//
//  SegHandlerType.swift
//  CAASExample
//
//  Created by slizeray on 29/06/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit


protocol SegueHandlerType {
    
    typealias SegueIdentifier: RawRepresentable
    
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier,
    sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
        segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier).")
        }
        return segueIdentifier
    }

}
