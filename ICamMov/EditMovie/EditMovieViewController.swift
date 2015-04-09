//
//  EditMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/9.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class EditMovieViewController: UIViewController, SunsetPlayerViewControllerDelegate{
    
    
    var isPlaying = false
    
    var movie : SunsetMovie?
    
    var tmpMovieURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var testURL = NSBundle.mainBundle().URLForResource("test", withExtension: "mp4")
        
        movie = SunsetMovie(URL: testURL!)
        
        println("edit movie")
        
//        var filter = SunsetFilter(name: "CIPhotoEffectProcess") // CIMotionBlur raise exception
//        movie!.addTarget(filter)
        
        var playerVC = childViewControllers[0] as SunsetPlayerViewController
        playerVC.delegate = self

        
        var outputFilePath: String = NSTemporaryDirectory().stringByAppendingPathComponent( "tmp".stringByAppendingPathExtension("mp4")!)
        var movieURL = NSURL(fileURLWithPath: outputFilePath)!
        var movieWriter = SunsetMovieWriter(newMovieURL: movieURL, newSize: CGSizeMake(640 , 360) )
        
        //        filter.addTarget(movieWriter)
        
        movie!.addTarget(movieWriter)
        movie!.addTarget(playerVC.playerView )
        
        movieWriter.startRecording()
        movie!.start()
        playerVC.play()
        
        
        //        var delayInSeconds  = 10
        var t = Int64( 5 * NSEC_PER_SEC )
        var stopTime = dispatch_time(DISPATCH_TIME_NOW, t )
        
//        dispatch_after(stopTime, dispatch_get_main_queue(), {
//            
//            movieWriter.finishRecording()
//            self.movie!.pause()
//            println("finish recording")
//        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playBtnClicked(){
        movie!.play()
    }
    func pauseBtnClicked(){
        
        movie!.pause()
    }

}