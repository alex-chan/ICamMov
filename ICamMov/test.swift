//
//  test.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/19.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class TestViewController: UIViewController, SAVideoRangeSliderDelegate{
    
    var tmpMovieURL: NSURL?
    
    @IBOutlet weak var trimBtn: UIButton!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var timeLabel: UILabel!
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("viewDidLoad")
        
        var videoFileUrl = Utils.getTestVideoUrl()
        
        
//        var path = NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!
//        var videoFileUrl = NSURL.fileURLWithPath(path)
//        
        
        var mySAVideoRangeSlider = SAVideoRangeSlider(frame: CGRectMake(10,200,self.view.frame.width, 70), videoUrl: videoFileUrl)
        
        mySAVideoRangeSlider.setPopoverBubbleSize(200, height:100)
        mySAVideoRangeSlider.delegate = self

        
        
        // Yellow
        mySAVideoRangeSlider.topBorder.backgroundColor = UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1)
        
        mySAVideoRangeSlider.bottomBorder.backgroundColor = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        
        self.view.addSubview(mySAVideoRangeSlider)

    }


}