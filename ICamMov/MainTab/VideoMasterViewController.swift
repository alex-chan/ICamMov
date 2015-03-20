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
    
    @IBOutlet weak var refreshNewVideoControl: UIRefreshControl!
    // MARK: Override functions
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        
        self.setupRefreshControl()
        
        
        
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if hasVideoData {
            return 1
        }else{
            
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
    @IBAction func refreshVideos(sender: UIRefreshControl) {
        if let refreshCtrl =  self.refreshControl {
            if refreshCtrl.refreshing{
                
//                println("end refreshing")
//                refreshCtrl.endRefreshing()
                
            }else{
            
                println("refresh ")
                AVCloud.callFunctionInBackground("refreshVideos", withParameters: ["test":"test"], target: self, selector: "refreshVideoResult:")
                
            }
        }
    }
    
    // MARK: Selectors
    func refreshVideoResult(result: AnyObject, error: NSError!){
        println("refreshVideoResult:")
        if error == nil{
            println("result:\(result)")
            
        }else{
            println(error.localizedDescription)
        }
        
        self.refreshControl!.endRefreshing()
        
        
    }
    
    // MARK: Custom functions
    func setupRefreshControl(){
        
    }
    
}



