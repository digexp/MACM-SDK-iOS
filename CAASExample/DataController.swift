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
    
    private var _mainUIPersistentStoreCoordinator:NSPersistentStoreCoordinator!
    
    public var mainUIPersistentStoreCoordinator:NSPersistentStoreCoordinator {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            self._mainUIPersistentStoreCoordinator = self.createPersistentStoreCoordinator()
        }
        
        return _mainUIPersistentStoreCoordinator
    
    }

    private var _writerPersistentStoreCoordinator:NSPersistentStoreCoordinator!
    
    public var writerPersistentStoreCoordinator:NSPersistentStoreCoordinator {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            self._writerPersistentStoreCoordinator = self.createPersistentStoreCoordinator()
        }
        
        return _writerPersistentStoreCoordinator
        
    }
    
    private func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        let dir = self.dynamicType.applicationLibraryDirectory().path?.stringByAppendingPathComponent("sql")
        
        let fileManager = NSFileManager.defaultManager()

        var error:NSError?
        
        var isDir:Bool
        
        let exists = fileManager.fileExistsAtPath(dir!)
        
        if !exists {
                fileManager.createDirectoryAtPath(dir!, withIntermediateDirectories: true, attributes: nil, error: &error)
            self.dynamicType.addSkipBackupAttributeToItemAtPath(dir!)
        }
        
        let storePath = self.dynamicType.applicationLibraryDirectory().path?.stringByAppendingPathComponent("sql/WR.sqlite")
        
        let storeUrl = NSURL(fileURLWithPath: storePath!)
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.mom)
        
        let r = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil, error: &error)
        
        if r == nil {
            assertionFailure("Can't create Persistent Store Coordinator \(error)")
        }
        
        return psc;
        
    }
    
    static public func removeStore() {
        let dir = applicationLibraryDirectory().path?.stringByAppendingPathComponent("sql")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(dir!) {
            var error:NSError?
            fileManager.removeItemAtPath(dir!, error: &error)
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
        
        return NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first! as! NSURL
        
    }
    
    private static func addSkipBackupAttributeToItemAtPath(path:String) -> Bool {
        
        var error:NSError?
        
        let url = NSURL.fileURLWithPath(path)
        url!.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey, error: &error)
        
        return error == nil
    }
    

    
}
