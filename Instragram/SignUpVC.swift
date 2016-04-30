//
//  SignUpVC.swift
//  Instragram
//
//  Created by 刘铭 on 16/4/28.
//  Copyright © 2016年 极客学院. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    
    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    // reset default size
    var scrollViewHeight:CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.height
        
        // check notifications if keyboard is show or not
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showKeyboard), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        // declare select image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // aligment
        avaImg.frame = CGRectMake(self.view.frame.width / 2 - 40, 40, 80, 80)
        usernameTxt.frame = CGRectMake(10, avaImg.frame.origin.y + 90, self.view.frame.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        repeatPassword.frame = CGRectMake(10, passwordTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        
        emailTxt.frame = CGRectMake(10, repeatPassword.frame.origin.y + 60, self.view.frame.width - 20, 30)
        fullnameTxt.frame = CGRectMake(10, emailTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        bioTxt.frame = CGRectMake(10, fullnameTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        webTxt.frame = CGRectMake(10, bioTxt.frame.origin.y + 40, self.view.frame.width - 20, 30)
        
        signUpBtn.frame = CGRectMake(20, webTxt.frame.origin.y + 50, self.view.frame.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.width - self.view.frame.width / 4 - 20, signUpBtn.frame.origin.y, self.view.frame.width / 4, 30)
        
        // background 
        let bg = UIImageView(frame: self.view.bounds)
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    // call picker to select image
    func loadImg(recoginizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // connect selected image to our image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // show keyboard
    func showKeyboard(notification: NSNotification) {
        
        // define keyboard size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        // move up UI
        UIView.animateWithDuration(0.4) { 
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    // hide keyboard func
    func hideKeyboard(notification: NSNotification) {
        
        // move down UI
        UIView.animateWithDuration(0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(recoginizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // clicked sign up
    @IBAction func signUpBtn_click(sender: AnyObject) {
        print("点击注册")
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
            
            // alert message
            let alert = UIAlertController(title: "注意", message: "请填写所有的字段", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // if different passwords
        if passwordTxt.text != repeatPassword.text {
            // alert message
            let alert = UIAlertController(title: "密码问题", message: "密码不匹配", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // send data to server to related columns
        let user = AVUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercaseString
        
        // in Edit Profile it's gonna be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        // convert out image for sending to server
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = AVFile(name: "ava.jpg", data: avaData)
        user["ava"]  = avaFile
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError!) in
            if success{
                print("注册成功！")
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
    
    // clicked cancel
    @IBAction func cancelBtn_click(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
