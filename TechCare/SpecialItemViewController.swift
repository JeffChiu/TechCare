//
//  SpecialItemViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/18.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class SpecialItemViewController: UIViewController {

    @IBOutlet weak var spName: UILabel!
    @IBOutlet weak var spTextField: UITextField!
    @IBOutlet weak var spUnit: UILabel!
    @IBOutlet weak var dpName: UILabel!
    @IBOutlet weak var dpTextField: UITextField!
    @IBOutlet weak var dpUnit: UILabel!
    @IBOutlet weak var hrName: UILabel!
    @IBOutlet weak var hrTextField: UITextField!
    @IBOutlet weak var hrUnit: UILabel!
    @IBOutlet weak var bsName: UILabel!
    @IBOutlet weak var bsTextField: UITextField!
    @IBOutlet weak var bsUnit: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func add(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
