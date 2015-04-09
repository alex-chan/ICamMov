//
//  utils.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/11.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


let PRODUCTION_ENV = false
let WEB_HOST = "icam.avosapps.com"



let kSAVideoRangeSliderWrappViewTag =  10001

class Utils {

    class func copyImageFromVideo(videoURL: NSURL, atTime: CMTime ) -> CGImage{
        
        
        var actualTime = CMTimeMake(0,0)
        var error: NSError?
        
        var asset = AVAsset.assetWithURL(videoURL) as AVAsset
        var imageGen = AVAssetImageGenerator(asset: asset)
        
        var cgImage = imageGen.copyCGImageAtTime(atTime, actualTime: &actualTime, error: &error) as CGImage
        
        return cgImage
        
        
    }
    
    class func getHost() -> String{
        if PRODUCTION_ENV {
            return "https://\(WEB_HOST)"
        }else{
            return "http://dev.\(WEB_HOST)"
        }
        
    }
    
    
    class func info(message: String, title: String? = nil){
        Utils.alert(title: title, message: message)
    }
    
    class func error(message: String, title: String? = "错误" ){
        Utils.alert(title: title, message: message)
    }
    

    class func alert(title: String? = nil,
                    message: String = "",
                    cancelBtnTitle: String? = "知道了"){
        
        var alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelBtnTitle)
        alertView.show()
    }
    
    
    
    class func dismissPresentedVC(vc: UIViewController,
                                animated:Bool = true,
                                completion: (()->Void)? = nil) {
        if let presentVC = vc.presentingViewController{
            presentVC.dismissViewControllerAnimated(animated, completion: completion)
        }
        
    }
    
    
    
    class func getTestVideoUrl() ->NSURL {
    
        var testURL =  NSBundle.mainBundle().URLForResource("test", withExtension: "mp4")
        println("testURL: \(testURL)" )
        return testURL!
    }
    
    class func getTestVideo2Url() ->NSURL {
        
        var testURL =  NSBundle.mainBundle().URLForResource("test2", withExtension: "mp4")
        return testURL!
    }
    
    

}