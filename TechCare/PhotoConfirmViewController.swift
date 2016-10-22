//
//  PhotoConfirmViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/22.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoConfirmViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photoUrl: String?
    var itemId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.sd_setImageWithURL(NSURL(string: photoUrl!))
        
        // Do any additional setup after loading the view.
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func confirm(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
