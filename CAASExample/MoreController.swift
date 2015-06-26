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


class MoreController: UITableViewController {

    enum Sections: Int {
        case SignOut
    }
    
    enum SignOut: Int {
        case SignOut
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height:30))
        
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        
        let appBuildNumber = infoDictionary["CFBundleVersion"] as! String
        let appVersionName = infoDictionary["CFBundleShortVersionString"] as! String
        
        let footer = "© 2015 IBM. CAAS \(appVersionName).\(appBuildNumber)"
        
        label.text = footer
        label.textAlignment = .Center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        label.textColor = UIColor.grayColor()
        
        self.tableView.tableFooterView = label
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentsSizeChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
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
        return maximum(Sections)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionEnum = Sections(rawValue: section)
        switch (sectionEnum!){
            case .SignOut:
                return maximum(SignOut)
            
        }
        
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Sections(rawValue: indexPath.section)
        switch (section!) {
            case .SignOut:
                let signOut = SignOut(rawValue: indexPath.row)
                switch (signOut!){
                case .SignOut:
                    let cell = tableView.dequeueReusableCellWithIdentifier("SignOutCellID", forIndexPath: indexPath) as!  SignOutCell
                    cell.updateFonts()
                    return cell
                }
            }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = Sections(rawValue: indexPath.section)
        switch (section!) {
            case .SignOut:
                let signOut = SignOut(rawValue: indexPath.row)
                switch signOut! {
                case .SignOut:
                    doSignOut()
            }
        }
        
    }
    
    func doSignOut() {
        
        let message = NSLocalizedString("Settings.SignOutAlert.Message", comment: "Message asking to confirm the sign out")
        let alert = UIAlertController(title: NSLocalizedString("Settings.SignOutAlert.Title",comment:"Title of the alert for signing out"), message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment:"Cancel"), style: .Cancel, handler: { (alertAction) -> Void in
            
            self.tableView.reloadData()
            
            //self.tableView.deselectRowAtIndexPath(NSIndexPath(forRow:Sections.SignOut.rawValue,inSection:SignOut.SignOut.rawValue), animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings.SignOutAlert.SignOut",comment:"SignOut button to confirm the sign out"), style: .Destructive, handler: { (alertAction) -> Void in
            
            dataController.emptyDatabase()
            caasService.signOut()
            
            let sb = UIStoryboard(name:"Main",bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("CAASSignInID")
            let window = UIApplication.sharedApplication().keyWindow
            
            UIView.transitionWithView(window!, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
                UIView.performWithoutAnimation({ () -> Void in
                    window!.rootViewController = vc;
                })
                }, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    func contentsSizeChanged(notification:NSNotification){
        self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
