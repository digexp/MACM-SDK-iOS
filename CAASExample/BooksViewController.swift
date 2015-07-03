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
import CoreData
import CAASObjC

private let wcmPath = "MACM Default Application/Content Types/Book"

class BooksViewController: UITableViewController {
    
    private var collapseDetailViewController = true
    
    private lazy var fetchedResultController:NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Book))
        
        let titleDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [titleDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        var error:NSError?
        if !frc.performFetch(&error) {
            assertionFailure("perform fetch error \(error)")
        }
        
        return frc
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.presentsWithGesture = true
        self.tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCellID")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        splitViewController!.delegate = self
        
        if splitViewController!.collapsed == false {
            var viewControllers = splitViewController!.viewControllers
            viewControllers[1] = createEmptyController()
            splitViewController!.viewControllers = viewControllers
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentsSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        self.refresh(self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionInfo = self.fetchedResultController.sections![section] as! NSFetchedResultsSectionInfo
        
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let book = self.fetchedResultController.objectAtIndexPath(indexPath) as! Book
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCellID", forIndexPath: indexPath) as! BookCell
        
        cell.caasService = caasService
        
        cell.book = book
        cell.updatefonts()
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let book: AnyObject = self.fetchedResultController.objectAtIndexPath(indexPath)
        
        self.performSegueWithIdentifier("ShowDetailBookSegID", sender: book)
        collapseDetailViewController = false
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let nc = segue.destinationViewController as! UINavigationController
        let bookVC = nc.topViewController as! BookViewController
        bookVC.book = sender as? Book
        
    }
    
    
    func contentsSizeChanged(notification:NSNotification){
        self.tableView.reloadData()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        
        self.refreshControl?.beginRefreshing()
        
        /*
        dataController.emptyDatabase()
        caasService.cancelAllPendingRequests()
        let contentItemsRequest = CAASContentItemsRequest(contentPath: wcmPath, completionBlock: { (requestResult) -> Void in
        if (requestResult.error != nil) || (requestResult.httpStatusCode != 200) {
        self.refreshControl?.endRefreshing()
        AppDelegate.presentNetworkError(requestResult.error,httpStatusCode: requestResult.httpStatusCode)
        } else if let contentItems = requestResult.contentItems as? [CAASContentItem] {
        dataController.seedDatabaseWithBooks(contentItems)
        self.refreshControl?.endRefreshing()
        }
        
        })
        */
        
        dataController.emptyDatabase()
        caasService.cancelAllPendingRequests()
        self.getPage()
        /*
        caasService.silentSignInWithCompletionHandler { (error, httpStatusCode) -> Void in
            if error != nil || !(200..<300).contains(httpStatusCode){
                AppDelegate.presentSignInError(error, httpStatusCode: httpStatusCode)
                self.refreshControl?.endRefreshing()
            } else {

                self.getPage()
            }
        }
        */
        
    }
    
    private func getPage(pageNumber:Int = 1){
        let contentItemsRequest = CAASContentItemsRequest(contentPath: wcmPath, completionBlock: { (requestResult) -> Void in
            if (requestResult.error != nil) || (requestResult.httpStatusCode != 200) {
                self.refreshControl?.endRefreshing()
                AppDelegate.presentNetworkError(requestResult.error,httpStatusCode: requestResult.httpStatusCode)
            } else if let contentItems = requestResult.contentItems as? [CAASContentItem] {
                dataController.seedDatabaseWithBooks(contentItems)
                if requestResult.morePages {
                    self.getPage(pageNumber: pageNumber + 1)
                    return
                }
                self.refreshControl?.endRefreshing()
            }
            
        })
        
        contentItemsRequest.elements = ["author","cover","isbn","price","publish_date","PDF"]
        contentItemsRequest.properties = ["id","title","keywords"]
        contentItemsRequest.pageSize = 10
        contentItemsRequest.pageNumber = pageNumber
        contentItemsRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        contentItemsRequest.geolocalized = true
        caasService.executeRequest(contentItemsRequest)
    
    }
    
    private func createEmptyController() -> UIViewController {
        let empty = NSLocalizedString("No Book Selected", comment:"No Book Selected")
        return EmptyViewController(emptyMessage: empty)
    }
    
}

extension BooksViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation:.Automatic)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch(type){
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            assertionFailure("change section in Table View failure")
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    
    
}

extension BooksViewController : UISplitViewControllerDelegate {
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        
        return collapseDetailViewController
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController!) -> UIViewController? {
        if let nc = primaryViewController as? UINavigationController{
            for vc in nc.viewControllers {
                if let _ = vc.containedBook(){
                    return nil
                }
            }
        }
        return createEmptyController()
    }
    
}

extension UIViewController {
    func containedBook() -> Book? {
        return nil
    }
}

extension UINavigationController {
    override func containedBook() -> Book? {
        for vc in viewControllers {
            if let b = vc.containedBook() {
                return b
            }
        }
        
        return nil
    }
}


