//
//  RegisterViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/18.
//  Copyright (c) 2015年 sunset. All rights reserved.
//



import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var verifyCode: UITextField!
    
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNum.delegate = self
        password.delegate = self
        verifyCode.delegate = self
    }
    
    // MARK: Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: actions
    @IBAction func closeSelf(sender: UIButton) {
        Utils.dismissPresentedVC(self)
    }
    
    @IBAction func presentLoginView(sender: UIButton) {
        if let presentingVC = self.presentingViewController  {
            presentingVC.dismissViewControllerAnimated(false, completion: {
                var loginView = self.storyboard!.instantiateViewControllerWithIdentifier("sid_vc_login") as LoginViewController
                presentingVC.presentViewController(loginView, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func sendVerifyCode(sender: UIButton) {
//        if countElements(phoneNum.text) != 11 {
            AVOSCloud.requestSmsCodeWithPhoneNumber(self.phoneNum.text, callback: {
                (succeed:Bool!, error:NSError!) in
                if succeed! {
                    Utils.info("信息已发送,请查收")
                }else{
                    Utils.error(error!.localizedDescription)
                }
            })
//        }
    }
    
    @IBAction func loginWithSinaWeibo(sender: UIButton) {

        AccountUtils.loginWithSinaWeibo(self)
        
    }
    
    @IBAction func register(sender: UIButton) {
        if countElements(password.text) < 6 {
            Utils.error("密码至少6位!")
            return
        }
        
        AVUser.signUpOrLoginWithMobilePhoneNumberInBackground(self.phoneNum.text, smsCode: self.verifyCode.text, block: {
            (user: AVUser!, error2:NSError!) in
            if error2 == nil {
                user.password = self.password.text
                
                user.saveInBackground()
                Utils.info("新用户注册成功", title: "恭喜您" )
                
                Utils.dismissPresentedVC(self)
                
            }else{
                println(" signup or login wrong")
                Utils.error(error2!.localizedDescription)
            }
        })
        

    }
    


}