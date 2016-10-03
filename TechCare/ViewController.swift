//
//  ViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/1.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
        
    }

    
    @IBAction func registerButton(sender: AnyObject) {
        let vc =  storyboard!.instantiateViewControllerWithIdentifier("Register") as! RegisterViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

