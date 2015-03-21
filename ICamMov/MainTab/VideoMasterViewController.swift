//
//  VideoMasterViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/20.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class VideoMasterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    
    var hasVideoData = true
    var isRefreshingVideos = false
    var videos : [AnyObject] = [["createdAt":"2323-323-1"]]
    
    
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
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "video_cell")
        
        var obj = self.videos[indexPath.row] as [String: AnyObject]
        cell.textLabel?.text = obj["createdAt"] as? String
        return cell
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
    func refreshVideoResult(result: AnyObject!, error: NSError!){
        
        self.isRefreshingVideos = false
        
        println("refreshVideoResult:")
        if error == nil{
            self.hasVideoData = true
//            self.videos = result["result"]
            println(result["result"])
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
    
    // MARK: Custom functions

    
}



