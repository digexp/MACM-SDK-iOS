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
import CAASObjC
import CoreData

var caasService:CAASService!

var dataController:DataController!

let kDidReceiveOfferings="com.ibm.DidReceiveOfferings"

let kDidReceiveBooks="com.ibm.DidReceiveBooks"

// ************************************************
//
//
// Specify your tenant in the global variable below
// ************************************************

let tenant:String = "PUT YOUR TENANT ID HERE !!!!!"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()

        CAASNetworkActivityIndicatorManager.sharedInstance().enabled = true
        
        dataController = DataController(modelName: "CAASExampleModel")
        DataController.removeStore()

        caasService = CAASService(baseURL: NSURL(string: "https://macm-rendering.saas.ibmcloud.com")!,contextRoot:"wps",tenant:tenant)
        
        if caasService == nil {
            assertionFailure("Wrong parameters")
        }
        
        if !caasService!.isUserAlreadySignedIn() {
            let sb = UIStoryboard(name:"Main",bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("CAASSignInID") as UIViewController!
            self.window!.rootViewController = vc
        }
        

        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    
    static func goInitialController() {
        
        let window = UIApplication.sharedApplication().keyWindow
        
        let sb = UIStoryboard(name:"Main",bundle:nil)
        let vc = sb.instantiateInitialViewController()!
        
        UIView.transitionWithView(window!, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
            UIView.performWithoutAnimation({ () -> Void in
                window!.rootViewController = vc
            })
            }, completion: nil)
        
        
    }
    
    
    static func presentSignInError(error:NSError?,httpStatusCode:Int){
        if (error != nil) || (httpStatusCode != 200) {
        
            let message:String
        
            if error != nil && error!.code == NSURLErrorCancelled {
                message = NSLocalizedString("SignIn.Alert.WrongCredentials",comment:"Wrong credentials")
            } else if error != nil {
                print("error \(error)")
                message = error!.localizedDescription
            } else {
                print("HTTPS Status \(httpStatusCode)")
                message = NSHTTPURLResponse.localizedStringForStatusCode(httpStatusCode)
            }
        
            let alert = UIAlertController(title: NSLocalizedString("SignIn.Alert.Title",comment:"Sign In Error"), message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
        
            }))
        
            let app = UIApplication.sharedApplication()
            let vc = app.delegate!.window!?.rootViewController
            vc!.presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    
    static func presentNetworkError(error:NSError?,httpStatusCode:Int){
        if (error != nil) || (httpStatusCode != 200) {
            
            let message:String
            
            if error != nil {
                print("error \(error)")
                message = error!.localizedDescription
            } else {
                print("HTTPS Status \(httpStatusCode)")
                message = NSHTTPURLResponse.localizedStringForStatusCode(httpStatusCode)
            }
            
            let alert = UIAlertController(title: NSLocalizedString("NetworkError.Alert.Title",comment:"Network Error"), message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: .Default, handler: { (alertAction) -> Void in
                
            }))
            
            let app = UIApplication.sharedApplication()
            let vc = app.delegate!.window!?.rootViewController
            vc!.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
}

