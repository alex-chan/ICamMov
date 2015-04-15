//
//  testViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/13.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import AVKit


class testViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        
//        var avVC = self.childViewControllers[0] as AVPlayerViewController
//        avVC.player = AVPlayer(URL: Utils.getTestVideoUrl())
        
        
//        
//        println("viewDidLoad")
//        println("frame:\(scrollView.frame)")
//        println("bounds:\(scrollView.bounds)")
//        println("contentSize:\(scrollView.contentSize)")
//        
//        println("superFrame:\(scrollView.superview!.frame)")
//        
//        scrollView.contentSize.height =    scrollView.superview!.bounds.height+20
//        
//        println("contentSize:\(scrollView.contentSize)")
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let scrollViewBounds = scrollView.bounds
        let contentViewBounds = contentView.bounds
        
        println("scrollViewBounds:\(scrollViewBounds)")
        println("contentViewBounds:\(contentViewBounds)")
        println("scrollViewInset:\(scrollView.contentInset.bottom)")

        
        scrollView.contentInset.bottom = scrollViewBounds.size.height - contentViewBounds.size.height + 1
    }
}