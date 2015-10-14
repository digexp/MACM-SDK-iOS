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

class PDFController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var book:Book!{
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let pdf = book.pdf {
            //webView.loadRequest(NSURLRequest(URL: NSURL(string: pdf)!))
            let assetRequest = CAASAssetRequest(assetURL: NSURL(string: pdf)!, completionBlock: { (assetResult) -> Void in
                if let data = assetResult.data {
                    self.webView.loadData(data, MIMEType: "application/pdf", textEncodingName: "", baseURL: NSURL(string: "localhost://www.example")!)
                }
            })
            caasService.executeRequest(assetRequest)
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
