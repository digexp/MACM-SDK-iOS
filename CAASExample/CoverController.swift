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

class CoverController: UIViewController {
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var book:Book!{
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
        self.cover.layer.borderWidth = 1/UIScreen.mainScreen().scale
        self.cover.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.cover.layer.cornerRadius = 4
        self.cover.backgroundColor = UIColor.lightGrayColor()
        */
        
        if let coverURL = book.cover {
            let imageURL = NSURL(string: coverURL, relativeToURL: caasService.baseURL)
            
            // check of the image is already in the cache
            if let image = imageCache?.objectForKey(imageURL!.absoluteString) as? UIImage {
                self.cover.image = image
                self.cover.setNeedsLayout()
                self.cover.layoutIfNeeded()
            } else {
                self.cover.hidden = true
                // Execute a request for getting an image
                self.activityIndicator.startAnimating()
                caasService.cancelAllPendingRequests()
                let imageRequest = CAASAssetRequest(assetURL: imageURL!) { (imageResult) -> Void in
                    self.activityIndicator.stopAnimating()
                    if let image = imageResult.image {
                        self.cover.image = image
                        self.cover.hidden = false
                        imageCache?.setObject(image, forKey: imageURL!.absoluteString)
                    } else {
                        if let error = imageResult.error {
                            print(error)
                        }
                        if imageResult.httpStatusCode > 0 {
                            print(imageResult.httpStatusCode)
                        }
                        
                    }
                }
                caasService.executeRequest(imageRequest)
            }
        } else {
            self.cover.hidden = true
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
