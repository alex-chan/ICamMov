//
//  LoginViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 15/3/7.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
    }
    
    
    // MARK: Delegates 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: actions
    @IBAction func closeSelf(sender: AnyObject) {
        Utils.dismissPresentedVC(self)
    }
    
    @IBAction func presentRegisterView(sender: UIButton) {
        
        if let presentingVC = self.presentingViewController  {
            presentingVC.dismissViewControllerAnimated(false, completion: {
                var registerView = self.storyboard!.instantiateViewControllerWithIdentifier("sid_vc_register") as RegisterViewController
                presentingVC.presentViewController(registerView, animated: true, completion: nil)
            })
        }
        
    }
    
    @IBAction func loginWithPhoneNum(sender: UIButton) {
        if countElements(username.text) != 11 {
            Utils.error("手机号必须为11位")
            return
        }
        
        
        AVUser.logInWithMobilePhoneNumberInBackground(username.text, password: password.text, block: {
            (user:AVUser!, error: NSError!) in
            if let err = error{
                Utils.error(err.localizedDescription)
            }else{
                Utils.dismissPresentedVC(self)
            }
            return
        })
    
    }
    
    @IBAction func loginWithSinaWeibo(sender: UIButton) {
            AccountUtils.loginWithSinaWeibo(self)
    }
    
    

    
//
//    func upsertUser(userInfo: ISSPlatformUser!){
//        
//        
//        var query = PFQuery(className: "TokenStorage")
//        query.whereKey("wb_uid", equalTo: userInfo.uid())
//        query.findObjectsInBackgroundWithBlock({
//            (objects: [AnyObject]!, error: NSError!) in
//            
//            println(objects)
//            
//            if( objects.count == 0 ){
//                println("this account not register ")
//                
//                self.newUser(userInfo)
//            }else{
//                
//                println("already register")
//                
//                var tokenData = objects[0] as PFObject
//                var user = tokenData.objectForKey("user") as PFUser
//                var accessToken = userInfo.credential().token()
//                
//                println("accessToken:" + accessToken)
//                println("user:")
//                println(user)
//
//                
//                if  accessToken != tokenData.objectForKey("accessToken") as NSString {
//                    tokenData.setObject(accessToken, forKey: "accessToken")
//                }
//                tokenData.saveInBackgroundWithBlock({
//                    (succeed: Bool!, error: NSError!) in
//                    if succeed! {
//                        var sessionToken = user.sessionToken
//                        
//                        println("sessionToken:")
//                        println(sessionToken)
//                        
//                        println("currentUser:")
//                        println(PFUser.currentUser() )
//                        
//                        PFUser.becomeInBackground(sessionToken, block: {
//                            (user: PFUser!, error: NSError!) in
//                            
//                            if error == nil{
//                                user.setObject(userInfo.nickname(), forKey: "nickname");
//                                user.setObject(userInfo.profileImage(), forKey: "avatar");
//                                user.saveInBackgroundWithBlock(nil);
//                                
//                            }else{
//                                println(error.localizedDescription)
//                            }
//                            
//
//
//                            
//                            
//                        });
//
//                        
//
//                    }
//                    
//                })
//                
//                
//                
//            }
//        })
//        
//    }
//    
//    func newUser(userInfo: ISSPlatformUser!){
//        println("new user ")
//        var user = PFUser()
//
//        var s = NSMutableData(length: 24)!
//        SecRandomCopyBytes(kSecRandomDefault, UInt(s.length), UnsafeMutablePointer<UInt8>(s.mutableBytes))
//        let base64str = s.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
//        
//        user.username = "wb_" + userInfo.uid()
//        user.password = base64str
//        user.signUpInBackgroundWithBlock({
//            (succeed: Bool!, error: NSError!) in
//            if succeed! {
//                var ts = PFObject(className: "TokenStorage")
//                ts.setObject(userInfo.uid(), forKey: "wb_uid")
//                ts.setObject(userInfo.credential().token(), forKey: "accessToken")
//                ts.setObject(user, forKey: "user")
//                var acl = PFACL()
//                acl.setPublicReadAccess(true)
//                acl.setPublicWriteAccess(false)
//                
//                ts.ACL = acl
//                
////                ts.setObject(acl, forKey: "ACL")
//                
//                ts.saveInBackgroundWithBlock(nil)
//            }
//        })
//        
//        
//    }
}