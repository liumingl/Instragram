//
//  SignInVC.swift
//  Instragram
//
//  Created by 刘铭 on 16/4/28.
//  Copyright © 2016年 极客学院. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    // textfield
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: "Pacifico", size: 25)

        titleLabel.frame = CGRectMake(10, 80, self.view.frame.width - 20, 50)
        usernameTxt.frame = CGRectMake(10, titleLabel.frame.origin.y + 70, self.view.frame.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        
        forgotBtn.frame = CGRectMake(10, passwordTxt.frame.origin.y + 30, self.view.frame.width - 20, 30)
        signInBtn.frame = CGRectMake(20, forgotBtn.frame.origin.y + 40, self.view.frame.width / 4, 30)
        signUpBtn.frame = CGRectMake(self.view.frame.width - self.view.frame.width / 4 - 20, signInBtn.frame.origin.y, self.view.frame.width / 4, 30)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: self.view.bounds)
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    func hideKeyboard(recoginizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // clicked sign in button
    @IBAction func signInBtn_click(sender: AnyObject) {
        print("登陆按钮被点击")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // is fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "注意", message: "请填写所有的字段", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // login func
        AVUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user:AVUser!, error:NSError!) in
            if error == nil {
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // call login function from AppDelegate class
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            }else {
                // show alert message
                let alert = UIAlertController(title: "错误", message: error.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
