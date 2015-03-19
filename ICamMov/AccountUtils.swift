//
//  AccountUtils.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/18.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
class AccountUtils {
    
    class func loginWithSinaWeibo(vc: UIViewController){
        
        
        ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil, result: {
            (result: Bool, userInfo: ISSPlatformUser!, error: ICMErrorInfo!) in
            if result {
                println("ok")
                
                var uid = userInfo.uid()
                var accessToken = userInfo.credential().token()
                var expiresIn = userInfo.credential().expired() as NSDate
                
                let expire = String(format:"%.2f", expiresIn.timeIntervalSinceNow)
                
                var authData = [ "uid": uid,
                    "access_token": accessToken,
                    "expiration_in": expire
                ]
                
                AVUser.loginWithAuthData(authData, platform: "weibo", block: {
                    (user: AVUser!, error: NSError!) in
                    if error == nil {
                        
                        if user.objectForKey("nickname") == nil {
                            user["nickname"] = userInfo.nickname()
                            user.saveInBackground()
                        }
                        if user.objectForKey("avatar") == nil{
                            user["avatar"] = userInfo.profileImage()
                            user.saveInBackground()
                        }
                        Utils.dismissPresentedVC(vc)
                        
                    }
                })
                
                
            }else{
                println("no ok")
                var alertView = UIAlertView(title: "错误", message: error.errorDescription(), delegate: nil, cancelButtonTitle: "知道了", otherButtonTitles: "")
                alertView.show()
                
                Utils.dismissPresentedVC(vc)
                
            }
            
            
        })
        
    }
}