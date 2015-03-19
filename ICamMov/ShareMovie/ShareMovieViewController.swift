//
//  ShareMovieViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 15/2/4.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import UIKit


class ShareMovieViewController : UIViewController{
    
    
    var toShareMovieURL : NSURL?
//    var coverImage: UIImage?
    
    var shareSettings :Dictionary<String, Bool> = ["save": true, "weixin_session": true, "weixin_timeline": false, "weibo": false]
    
    
    
    var progressView: UIProgressView?
    
    
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var saveMovieBtn: UIButton!
    @IBOutlet weak var shareWeixinBtn: UIButton!
    @IBOutlet weak var shareWeiboBtn: UIButton!
    @IBOutlet weak var shareTimelineBtn: UIButton!
    
    
    @IBOutlet weak var shareComment: BorderTextView!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        println("toShareMovieURL:\(self.toShareMovieURL!)")
        
        
        self.setCover()
    }
    
    
    // MARK: custon functions
    
    func setCover(){
        
        if self.toShareMovieURL != nil {
            
            var cgImage = Utils.copyImageFromVideo(self.toShareMovieURL!, atTime: kCMTimeZero)
            
            var uiImage = UIImage(CGImage: cgImage)
            
            self.coverImage.image = uiImage
            
        }
    }
    


    func mineACL() -> AVACL {
        var acl = AVACL()
        acl.setPublicWriteAccess(false)
        acl.setWriteAccess(true, forUser: AVUser.currentUser())

        return acl
    }
    
    
    func dispatchShare(shareUrl: String){
        if self.shareSettings["save"]! {
            
        }
        if self.shareSettings["weixin_session"]! {
            self.shareInWeixin(ShareTypeWeixiSession, shareUrl: shareUrl)
        }
        if self.shareSettings["weixin_timeline"]! {
            self.shareInWeixin(ShareTypeWeixiTimeline, shareUrl: shareUrl)
        }
        
        
    }
    
    func shareInWeixin(type: ShareType, shareUrl: String){
        
        
        
        println("shareULR:\(shareUrl)")
        
        var title = shareComment.text
        var image = coverImage.image
        var coverFile =  UIImagePNGRepresentation(image)
        
        var shareImage = ShareSDK.imageWithData(coverFile, fileName: "coverImage", mimeType: "image/png")
        
        var publishContent : ISSContent = ShareSDK.content("",
            defaultContent:"默认分享内容，没内容时显示",
            image:shareImage,
            title:title,
            url:shareUrl,
            description:title,
            mediaType:SSPublishContentMediaTypeVideo)
        
        
        ShareSDK.clientShareContent(publishContent,
            type: type,
            authOptions: nil,
            shareOptions: nil,
            statusBarTips: true,
            result: {
                
                (type:ShareType, state:SSResponseState , statusInfo:ISSPlatformShareInfo!, error:ICMErrorInfo!, end:Bool) in
                
                println(state.value)
                
                
                switch state.value {
                    case SSResponseStateSuccess.value:
                        println("分享成功")
                    case SSResponseStateFail.value:
                        println(error.errorCode())
                        println(error.errorDescription())
                    default:
                        println("other")
                        
                }
                
        })
    }
    
    typealias UploadFileResultBlock = (Bool!, NSError?, AVFile?)->Void
    
    func uploadCoverAndMovie(){
        
        var sessionQueue: dispatch_queue_t = dispatch_queue_create("upload file session queue",DISPATCH_QUEUE_SERIAL)
        
//        self.sessionQueue = sessionQueue
        
        var alert = UIAlertView(title: "上传中...", message: nil, delegate: nil, cancelButtonTitle:nil)
        var progress = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        
        
        progress.frame = CGRectMake(0, 0, 200, 15)
        progress.bounds = CGRectMake(0, 0, 200, 15)
        progress.progress = 0.0;
        progress.backgroundColor = UIColor.blackColor()
        progress.userInteractionEnabled = false
        progress.trackTintColor = UIColor.blueColor()
        progress.progressTintColor = UIColor.redColor()
        
        alert.setValue(progress, forKey: "accessoryView")
        
//        alert.addSubview(progress)
        
        self.progressView = progress
        alert.show()
        
        dispatch_async(sessionQueue, {
            var error: NSError?
            var coverFile = self.uploadCoverImage(&error)
            
            if error != nil{
                dispatch_async(dispatch_get_main_queue(), {
                    alert.dismissWithClickedButtonIndex(0, animated: true)
                    var alert2 = UIAlertView(title: "上传错误", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "知道了")
                    alert2.show()
                })
            }
            
            self.uploadMovie({
                
                (succeed:Bool!, error:NSError?, videoFile: AVFile?) in
                
                if succeed! {
                    var video = AVObject(className: "Video")
                    
                    video["owner"] = AVUser.currentUser()
                    video["videoFile"] = videoFile!
                    video["coverImage"] = coverFile
                    video.ACL = self.mineACL()
                    video.save()
                    
//                    var error: NSError?
//                    var host = AVCloud.callFunction("hello", withParameters: nil, error: &error)
//                    if let err = error{
//                        println("error:\(err.localizedDescription)")
//                    }
//                    
//                    println("host: \(host)")
//                    
//                    let url = "\(host)/videos/\(video.objectId)"
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        
                        var shareUrl = "\(Utils.getHost())/videos/\(video.objectId)"
                        self.dispatchShare(shareUrl)
                        
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        alert.dismissWithClickedButtonIndex(0, animated: true)
                        var alert2 = UIAlertView(title: "上传错误", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "知道了")
                        alert2.show()
                    })
                    
                }
                

                
            })
            
            
            
        })

  
        
    }
    
    func uploadCoverImage(error: NSErrorPointer) -> AVFile {
        
        var image = coverImage.image
        var coverFile =  UIImagePNGRepresentation(image)
        
        var coverAVFile = AVFile.fileWithName("cover.png", data: coverFile) as AVFile
        coverAVFile.setOwnerId(AVUser.currentUser().objectId)
        coverAVFile.save( error)
        
        return coverAVFile
        
//        coverAVFile.saveInBackgroundWithBlock({
//            (succeed: Bool!, error: NSError!) in
//            if succeed! {
//                self.uploadMovie()
//                
//            }else{
//                println(error.localizedDescription)
//            }
//        })
    }
    
    

    
    func uploadMovie(resultBlock: UploadFileResultBlock){


        
        var videoData = NSData(contentsOfURL: self.toShareMovieURL!)
        
        
        var videoFile: AVFile = AVFile.fileWithName("video.mp4",  data: videoData) as AVFile
        
        videoFile.setOwnerId(AVUser.currentUser().objectId)
        
        
        
        videoFile.saveInBackgroundWithBlock({
            (succeed: Bool!, error: NSError!) in
            
            resultBlock(succeed, error, videoFile)
            
        }, progressBlock: {
//            (percentDone: Int32) in  // use this line when use Parse.com
            (percentDone: Int) in
            //
            
            dispatch_async(dispatch_get_main_queue(), {

                
//                self.progressView!.progress = Float(percentDone) / 100.0
                
                self.progressView!.setProgress(Float(percentDone) / 100.0, animated: true)
                
                println("proessView:\(self.progressView!.progress)" )
                return
            })
            
            println(percentDone)
                
        })
        

        
        
    }
    
    // MARK: actions
    
    
    @IBAction func saveMovie(sender: UIButton) {
     
        if self.shareSettings["save"]! {
            sender.setImage(UIImage(named: "Save_gray"), forState: UIControlState.Normal)
        }else{
            sender.setImage(UIImage(named: "Save"), forState: UIControlState.Normal)
        }
        self.shareSettings["save"] = !self.shareSettings["save"]!
        
    }
    
    @IBAction func shareWeixinSession(sender: UIButton) {
        if self.shareSettings["weixin_session"]! {
            sender.setImage(UIImage(named: "WX_LOGO_GRAY"), forState: UIControlState.Normal)
        }else{
            sender.setImage(UIImage(named: "WX_LOGO"), forState: UIControlState.Normal)
            if self.shareSettings["weixin_timeline"]! {
                self.shareTimelineBtn.setImage(UIImage(named: "WX_TL_LOGO_GRAY"), forState: UIControlState.Normal)
                self.shareSettings["weixin_timeline"] = false
            }
        }
        self.shareSettings["weixin_session"] = !self.shareSettings["weixin_session"]!
    }
    
    @IBAction func ShareWeibo(sender: UIButton) {
        if self.shareSettings["weibo"]! {
            sender.setImage(UIImage(named: "WB_LOGO_GRAY"), forState: UIControlState.Normal)
        }else{
            sender.setImage(UIImage(named: "WB_LOGO"), forState: UIControlState.Normal)
        }
        self.shareSettings["weibo"] = !self.shareSettings["weibo"]!
    }
    

    
    @IBAction func shareTimeline(sender: UIButton) {

        if self.shareSettings["weixin_timeline"]! {
            sender.setImage(UIImage(named: "WX_TL_LOGO_GRAY"), forState: UIControlState.Normal)
        }else{
            sender.setImage(UIImage(named: "WX_TL_LOGO"), forState: UIControlState.Normal)
            if self.shareSettings["weixin_session"]! {
                self.shareWeixinBtn.setImage(UIImage(named: "WX_LOGO_GRAY"), forState: UIControlState.Normal)
                self.shareSettings["weixin_session"] = false
            }
        }
        self.shareSettings["weixin_timeline"] = !self.shareSettings["weixin_timeline"]!
    }
    
    @IBAction func share(sender: UIButton) {
        
        println(PFUser.currentUser())

        if AVUser.currentUser() == nil {
            var loginView = self.storyboard!.instantiateViewControllerWithIdentifier("sid_vc_login") as LoginViewController
            
            self.presentViewController(loginView, animated: true, completion:nil)
            
        }else{
            println("current user exists")
            
            var atleastOneTrue = false
            for val in self.shareSettings.values {
                if val {
                    atleastOneTrue = true
                    break
                }
            }
            if !atleastOneTrue {
                var alertView = UIAlertView(title: "错误", message: "请至少选择一项保存或分享", delegate: nil, cancelButtonTitle: "知道了")
                alertView.show()
                
                
                return
            }
            self.uploadCoverAndMovie()
        }
        
        return
        
        var imagePath = NSBundle.mainBundle().pathForResource("img1", ofType: "jpg")
        
        
//        var publishContent:ISSContent = ShareSDK.content("分享内容", defaultContent: "测试分享", image: ShareSDK.imageWithPath(imagePath), title: "Share", url: "http://test.com", description: "just a test message", mediaType: SSPublishContentMediaTypeNews)
        //        var container: ISSContainer = ShareSDK.container()
        //        container.setIPadContainerWithView(sender, arrowDirect: UIPopoverArrowDirection.Up)
        
        var publishContent : ISSContent = ShareSDK.content("分享文字", defaultContent:"默认分享内容，没内容时显示",image:nil, title:"提示",url:"http://icammov.geek-link.com",description:"这是一条测试信息",mediaType:SSPublishContentMediaTypeNews)

//        var shareList  = ShareSDK.getShareListWithType(ShareTypeSinaWeibo, ShareTypeWeixiSession,ShareTypeWeixiTimeline )
        
           ShareSDK.showShareActionSheet(nil,
                                shareList: nil,
                                content: publishContent,
                                statusBarTips: true,
                                authOptions: nil,
                                shareOptions: nil,
                                result: {
                                    (type:ShareType, state:SSResponseState , statusInfo:ISSPlatformShareInfo!, error:ICMErrorInfo!, end:Bool) in
                                        println(state.value)
                                    
                                    
                                    switch state.value {
                                    case SSResponseStateSuccess.value:
                                        println("分享成功")
                                    case SSResponseStateFail.value:
                                        println(error.errorCode())
                                        println(error.errorDescription())
                                    default:
                                        println("other")

                                    }
                                    
                
                                    
                                }
        )
    }

}