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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var avVC = self.childViewControllers[0] as AVPlayerViewController
        avVC.player = AVPlayer(URL: Utils.getTestVideoUrl())
    }
}