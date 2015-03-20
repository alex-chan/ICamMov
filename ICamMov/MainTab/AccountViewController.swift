//
//  SecondViewController.swift
//  TryDemo
//
//  Created by sunset on 14-11-26.
//  Copyright (c) 2014年 sunset. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var logInOutCell: UITableViewCell!
    @IBOutlet weak var logInOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        self.refreshInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Custom functions
    func refreshInfo(){
        
        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
        self.avatar.layer.masksToBounds  = true
        self.avatar.layer.borderWidth = 0
        println("cornerRadius:\(self.avatar.layer.cornerRadius)")
        
        if let curUser = AVUser.currentUser() {
            
            
            if let nickname = curUser["nickname"] as? String {
                self.nickname.text = nickname
            }else{
                self.nickname.text = "无名"
            }
            
            var manager = SDWebImageManager.sharedManager()
            
            if let avatarStr = curUser["avatar"] as? String {
                var orginalImageUrl = NSURL(string: avatarStr)
                manager.downloadImageWithURL( orginalImageUrl,
                    options: SDWebImageOptions.LowPriority,
                    progress:{
                        (receivedSize: NSInteger, expectedSize: NSInteger) in
                        return
                        
                    },
                    completed: {
                        (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished:Bool, imageURL:NSURL!) in
                        if let img = image {
                            self.avatar.image = img
                        }
                        return
                        
                    }
                )
                
            }
            
            self.logInOutLabel.text = "退出登录"
            
        }else{
            self.nickname.text = "未登录"
            self.logInOutLabel.text = "登录"
            self.avatar.image = UIImage(named: "DefaultAvatar")
        }
    }
    
    // MARK: Tableview data source delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellClicked = tableView.cellForRowAtIndexPath(indexPath)
        if cellClicked == self.logInOutCell {
            if let user = AVUser.currentUser() {
                AVUser.logOut()
                self.refreshInfo()
            }else{
                AccountUtils.presentLoginView(self)
            }
        }
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }

}

