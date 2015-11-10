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

class PageViewController: UIPageViewController {

    var coverVC:CoverController!
    var pdfVC:PDFController!
    var children = [UIViewController]()
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        // Do any additional setup after loading the view.
        
        
        if let _ = book?.cover {
            self.coverVC = self.storyboard?.instantiateViewControllerWithIdentifier("CoverIDVC") as! CoverController
            self.coverVC.book = book
            self.children.append(self.coverVC)
        }
        
        if let _ = book?.pdf {
            self.pdfVC = self.storyboard?.instantiateViewControllerWithIdentifier("PDFIDVC") as! PDFController
            self.pdfVC.book = book
            self.children.append(self.pdfVC)
        }
        
        if children.count > 0 {
            self.setViewControllers([self.children[0]], direction: .Forward, animated: false, completion: nil)
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

extension PageViewController:UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if let index = self.children.indexOf(viewController) where index > 0 {
            return self.children[index-1]
        } else {
            return nil
        }
        
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let index = self.children.indexOf(viewController) where index < children.count - 1 {
            return self.children[index+1]
        } else {
            return nil
        }
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.children.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension PageViewController:UIPageViewControllerDelegate {
    
}
