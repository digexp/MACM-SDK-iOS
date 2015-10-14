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
import CoreData


public class DataController:NSObject {
    
    public let modelName:String

    private var _mainContext:NSManagedObjectContext!
    
    public init(modelName:String){
            self.modelName = modelName
    }
    
    // Main context for the UI
    public var mainContext:NSManagedObjectContext  {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            let coordinator = self.mainUIPersistentStoreCoordinator
            
            self._mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            self._mainContext.persistentStoreCoordinator = coordinator
            self._mainContext.undoManager = nil
        }
        return _mainContext
    }
    
    private var _writerContext:NSManagedObjectContext!
    // Writer context
    public var writerContext:NSManagedObjectContext  {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            let coordinator = self.writerPersistentStoreCoordinator
            
            self._writerContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            self._writerContext.persistentStoreCoordinator = coordinator
            self._writerContext.undoManager = nil
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextChanged:", name: NSManagedObjectContextDidSaveNotification, object: self._writerContext)
        }
        
        return _writerContext
    }
    
    
    private lazy var mom:NSManagedObjectModel = {
    
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")

        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    
    } ()
    
    
    public lazy var mainUIPersistentStoreCoordinator:NSPersistentStoreCoordinator = {
            return self.createPersistentStoreCoordinator()
    
    }()

    public lazy var writerPersistentStoreCoordinator:NSPersistentStoreCoordinator = {
        
        return self.createPersistentStoreCoordinator()
        
    }()
    
    private func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        let dir = self.dynamicType.applicationLibraryDirectory().path?.NS.stringByAppendingPathComponent("sql")
        
        let fileManager = NSFileManager.defaultManager()

        let exists = fileManager.fileExistsAtPath(dir!)

        do {
            if !exists {
                    try fileManager.createDirectoryAtPath(dir!, withIntermediateDirectories: true, attributes: nil)
                self.dynamicType.addSkipBackupAttributeToItemAtPath(dir!)
            }
            
            let storePath = self.dynamicType.applicationLibraryDirectory().path?.NS.stringByAppendingPathComponent("sql/WR.sqlite")
            
            let storeUrl = NSURL(fileURLWithPath: storePath!)
            
            let psc = NSPersistentStoreCoordinator(managedObjectModel: self.mom)
            
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil)
            return psc
        } catch {
            fatalError("Can't create Persistent Store Coordinator \(error)")
        }
        
        
    }
    
    static public func removeStore() {
        let dir = applicationLibraryDirectory().path?.NS.stringByAppendingPathComponent("sql")
        let fileManager = NSFileManager.defaultManager()
        do {
            if fileManager.fileExistsAtPath(dir!) {
                try fileManager.removeItemAtPath(dir!)
            }
        } catch {
            print("Can't remove the core data store")
        }
        
        
    }

    func contextChanged(notification:NSNotification) {
    // If we get change from an other thread, we merge the changes
        if notification.object as! NSManagedObjectContext != self.mainContext {
            self.mainContext.performBlock({ () -> Void in
                self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
            })
        
        }
    }
    

}

extension DataController {
    // Returns the URL to the application's Library directory.
    private static func applicationLibraryDirectory() -> NSURL {
        
        return NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first! as NSURL
        
    }
    
    private static func addSkipBackupAttributeToItemAtPath(path:String) {

        do {
            let url = NSURL.fileURLWithPath(path)
            try url.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
        } catch {
            fatalError("Can't set exclude from backup atribute \(error)")
        }
    }
    

    
}

extension String {
    
    var NS:NSString {
        return NSString(string: self)
    }
    
}
