//
//  ResetPasswordVC.swift
//  Instragram
//
//  Created by 刘铭 on 16/4/28.
//  Copyright © 2016年 极客学院. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    // textfields
    @IBOutlet weak var emailTxt: UITextField!
    
    // buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.frame = CGRectMake(10, 120, self.view.frame.width - 20, 30)
        resetBtn.frame = CGRectMake(20, emailTxt.frame.origin.y + 50, self.view.frame.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.width - self.view.frame.width / 4 - 20, resetBtn.frame.origin.y, self.view.frame.width / 4, 30)
        
        // background
        let bg = UIImageView(frame: self.view.bounds)
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // clicked reset button
    @IBAction func resetBtn_click(sender: AnyObject) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // email textfield is empty 
        if emailTxt.text!.isEmpty {
            // alert message
            let alert = UIAlertController(title: "电子邮件", message: "电子邮件是空的！", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        AVUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (success:Bool, error:NSError!) in
            if success {
                let alert = UIAlertController(title: "重置密码到邮件", message: "邮件已经发送！", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "知道了", style: .Default, handler: { (UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }else {
                print(error.localizedDescription)
            }
        }
    }

    // clicked cancel button
    @IBAction func cancelBtn_click(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
