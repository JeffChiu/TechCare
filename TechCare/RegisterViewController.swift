//
//  RegisterViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/1.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //居服員
    @IBOutlet weak var licenseName: UILabel!
    @IBOutlet weak var lecenseTextField: UITextField!
    @IBOutlet weak var licenseExpireDate: UILabel!
    @IBOutlet weak var licenseExpireDateTextField: UITextField!
    @IBOutlet weak var trainingPlace: UILabel!
    @IBOutlet weak var trainingPlaceTextField: UITextField!
    @IBOutlet weak var specialSkill: UILabel!
    @IBOutlet weak var specialSkillTextField: UITextField!
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var experienceTextField: UITextView!
    @IBOutlet weak var introduce: UILabel!
    @IBOutlet weak var introduceTextField: UITextView!
    
    //案主
    
    
    @IBOutlet weak var roleType: UISegmentedControl!
    
    
    @IBAction func roleType(sender: AnyObject) {
        switch roleType.selectedSegmentIndex {
        case 0 :
            //居服員
            licenseName.hidden = true
            lecenseTextField.hidden = true
            licenseExpireDate.hidden = true
            licenseExpireDateTextField.hidden = true
            trainingPlace.hidden = true
            trainingPlaceTextField.hidden = true
            specialSkill.hidden = true
            specialSkillTextField.hidden = true
            experience.hidden = true
            experienceTextField.hidden = true
            introduce.hidden = true
            introduceTextField.hidden = true
            
            //案主
            
            break
        case 1 :
            //居服員
            licenseName.hidden = false
            lecenseTextField.hidden = false
            licenseExpireDate.hidden = false
            licenseExpireDateTextField.hidden = false
            trainingPlace.hidden = false
            trainingPlaceTextField.hidden = false
            specialSkill.hidden = false
            specialSkillTextField.hidden = false
            experience.hidden = false
            experienceTextField.hidden = false
            introduce.hidden = false
            introduceTextField.hidden = false
            introduce.hidden = false
            introduceTextField.hidden = false
            break
        case 2 : break
        default : break
            
        }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //居服員
        licenseName.hidden = true
        lecenseTextField.hidden = true
        licenseExpireDate.hidden = true
        licenseExpireDateTextField.hidden = true
        trainingPlace.hidden = true
        trainingPlaceTextField.hidden = true
        specialSkill.hidden = true
        specialSkillTextField.hidden = true
        experience.hidden = true
        experienceTextField.hidden = true
        introduce.hidden = true
        introduceTextField.hidden = true
        
    }

    @IBAction func registerDone(sender: AnyObject) {
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
