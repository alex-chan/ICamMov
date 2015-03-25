//
//  VideoMasterViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/20.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class VideoMasterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    
    var hasVideoData = false
    var isRefreshingVideos = false
    var videos : [LPVideo] = []
    
    var currentPlayer: AVPlayer?
    
    @IBOutlet weak var refreshNewVideoControl: UIRefreshControl!
    
    // MARK: Override functions
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        
    }

    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print("number of sections:")
        
        if self.hasVideoData {
            println("1")
            return 1
        }else{
            println("0")
            var label = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height))
            label.text = "没有视频喔，请下拉刷新"
            label.textColor = UIColor.blackColor()
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.sizeToFit()
            
            self.tableView.backgroundView = label
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            return 0
            
        }
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("number of rows: \(countElements(self.videos))")
        println("number of rows: \(countElements(videos))")
        return countElements(self.videos)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("cellForRowAtIndexPath")
        
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("video_cell") as VideoMasterCell
        
//        
        var video = self.videos[indexPath.row] as LPVideo
        
        println("video: createdAt:\(video.createdAtCopy)")
        
        
        
        
        var user = video.owner!.fetchIfNeeded()
        
        
        println(user)
        var nick = "Unset"
        if let u = user as? LPUser{
            if let nick2  = u.nickname {
                nick = nick2
            }else{
                println("user nick name is null")
            }
            
        }else{
            println("user is null")
            
        }
        
        println("nick:\(nick)")
        
        cell.nickname.text = nick
        cell.postTime.text = video.createdAtCopy
        
//        cell.videoContent.player = AVPlayer()
        
        cell.videoURL = video.videoFile!.url
        
//        self.loadVideoItem(cell, url: video.videoFile!.url)
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var mycell =  cell as VideoMasterCell
        self.loadVideoItem(mycell, url: mycell.videoURL!)
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var mycell = cell as VideoMasterCell
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: mycell.videoContent.player)
        
        
    }
    
    
    // MARK: Actions
    @IBAction func refreshVideos(sender: UIRefreshControl) {
        println("refresh ")
        if !self.isRefreshingVideos {
            // Selector Problem :http://stackoverflow.com/questions/24007650/selector-in-swift
            AVCloud.callFunctionInBackground("refreshVideos", withParameters: nil, target: self, selector: "refreshVideoResult:error:")
            self.isRefreshingVideos = true
        }
        
    }
    
    // MARK: Selectors
    
    
    func refreshVideoResult(result: [AnyObject]!, error: NSError!){
        
        self.isRefreshingVideos = false
        
        println("refreshVideoResult:")
        if error == nil{
            self.hasVideoData = true
//            self.videos = result["result"]
            
            println(result)
            println("--------")
            
            self.videos = []
            
            
            
            for video in result {
//                let v2 = video as LPVideo
//                println(v2)
//                println(v2.createdAt)
//                println(v2.coverImage)
//                println(v2.owner)
                
                
                let v1 = video as [String:AnyObject]
                let v2 = LPVideo(withoutDataWithObjectId: video.objectId)
                
                
                let u1 = v1["owner"] as AVUser
                let u2 = AVUser(withoutDataWithObjectId: u1.objectId)
                u2["avatar"] = u1["avatar"] as? String
                u2["nickname"] = u1["nickname"] as? String
                
                v2.owner = v1["owner"] as LPUser
                v2.coverImage = v1["coverImage"] as AVFile
                v2.videoFile = v1["videoFile"] as AVFile
//                println(v1["createdAt"])
//                println(v1["createdAt"].self)
//                
//                
//                println(v2.createdAt)
                
                
                v2.createdAtCopy = v1["createdAt"] as String
                v2.updatedAtCopy = v1["updatedAt"] as String
                

                
                self.videos.append(v2)
                
                
                
            }
            
            
            self.hasVideoData = true
//            var videos = result as [AnyObject]
//            
//            for video in videos {
//                let vd = video as [String:AnyObject]
//                println(vd["createdAt"])
//            }
//            
//            println(result["result"])
//            println(result["result"][0])
//            println(result["result"][0]["createdAt"])
            
            self.tableView.reloadData()
            
//            println("result:\(result)")
            
        }else{
            println(error.localizedDescription)
            Utils.alert(message: error.localizedDescription)
        }
        
        self.refreshControl!.endRefreshing()
        
        
    }
    
    func videoItemDidReachEnd(notification: NSNotification){
        var item = notification.object as AVPlayerItem
        item.seekToTime(kCMTimeZero)
        
    }
    
    // MARK: Custom functions
    
    func loadVideoItem(cell: VideoMasterCell, url: String){
        var nsurl = NSURL(string: url)
        var tracksKey = "tracks"
        var asset = AVURLAsset(URL: nsurl, options: nil)
        asset.loadValuesAsynchronouslyForKeys([tracksKey], completionHandler: {
            var error: NSError?
            var status = asset.statusOfValueForKey(tracksKey, error: &error)
            
            if status == AVKeyValueStatus.Loaded {
                var item = AVPlayerItem(asset: asset)
                var player = AVPlayer(playerItem: item)
                player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object:
                    player.currentItem)
                
                dispatch_async(dispatch_get_main_queue(), {
                    cell.videoContent.player = player
                    print("cell frame: \(cell.videoContent.frame)")
                    player.play()
                })
                
                
                
            }else{
                print("error load track:")
                println(error)
            }
            
        })
        
    }

    
}



