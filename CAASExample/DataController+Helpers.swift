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


import Foundation
import CAASObjC
import CoreData

var imageCache:NSCache?

extension DataController
{
    
    func seedDatabaseWithBooks(contentItems:[CAASContentItem]) {
        imageCache = NSCache()
        let moc = self.writerContext
        moc.performBlock { () -> Void in
            for contentItem in contentItems {
                let book = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(Book), inManagedObjectContext: moc) as! Book
                let elements = contentItem.elements
                let properties = contentItem.properties
                
                var values:[NSObject:AnyObject] = [:]
                
                values.update(elements)
                values.update(properties)
                
                for (var key,var value) in values {
                    if value is NSNull {
                        continue
                    }
                    if let url = value as? NSURL {
                        value = url.absoluteString
                    }
                    key = (key as! String).lowercaseString
                    book.setValue(value, forKey: key as! String)
                }
                
                book.title = properties["title"] as? String
                
            }
            do {
                
                try moc.save()
                
            } catch {
                fatalError("Code Data Error \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveBooks, object: self)
            })
        }
    }
    
    func emptyDatabase() {
        let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Book))
        let moc = self.writerContext
        moc.performBlock { () -> Void in
            do {
                let mos = try moc.executeFetchRequest(fetchRequest)
                
                for mo in mos as! [NSManagedObject]{
                    moc.deleteObject(mo)
                }
            
                try moc.save()
                
            } catch {
                fatalError("Core Data Error \(error)")
            }
            
            moc.reset()
        }
        
    }
}


extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


