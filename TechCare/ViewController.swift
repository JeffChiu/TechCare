//
//  ViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/1.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    
    @IBOutlet weak var acc: UITextField!
    @IBOutlet weak var pwd: UITextField!
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    var window: UIWindow?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }

    
    //有問題，還沒等驗證結果就過場了
    func login() -> Bool {
        var returnVal = false
        if acc.text != nil && pwd.text != nil {
            let urlString: String = "\(TechCareDef.HOST)/api/v1/login"
            Alamofire.request(.POST, urlString, parameters: [
                "email" : acc.text! ,
                "password" : pwd.text!
                //"email" : "beautiful@hotmail.com",
                //"password" : "123123"
                ]).responseJSON(){
                    response in
                    if let jsonData = response.result.value {
                        print("login api response : \(jsonData)")
                        let json = JSON(jsonData)
                        let status = json["status"].stringValue
                        let message = json["message"].stringValue
                        let application_token = json[TechCareDef.APPLICATION_TOKEN].stringValue
                        let IsCaregiver = json["IsCaregiver"].boolValue
                        if status == "200" {
                            self.userDefault.setObject(application_token, forKey: TechCareDef.APPLICATION_TOKEN)
                            self.userDefault.setObject(IsCaregiver, forKey: "IsCaregiver")
                            self.userDefault.synchronize()
                            
                            print("application_token = \(self.userDefault.stringForKey(TechCareDef.APPLICATION_TOKEN)) , IsCaregiver = \(IsCaregiver)")
                            
                            returnVal = true
                        } else {
                            let alert = UIAlertController(title: "系統連線異常", message: nil, preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(ok)
                            self.presentViewController(alert, animated: true, completion: nil)
                            print("\(#function) error : api response message = \(message)")
                            
                        }
                        
                    }
            }
            
        } else {
            
        }
        
        return returnVal
    }
    
    //vc 過場至 tab bar 的 第一個 tab
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TabBarSegue" {
            if login() == true {
                let barViewControllers = segue.destinationViewController as! UITabBarController
                let nav = barViewControllers.viewControllers![0] as! UINavigationController
                let _ = nav.topViewController as! RequesterListViewController
            }
        }
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

