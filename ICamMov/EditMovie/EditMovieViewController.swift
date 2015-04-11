//
//  EditMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/9.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class EditMovieViewController: UIViewController, SunsetPlayerViewControllerDelegate, FilterCollectionViewDelegate{
    
    
    var isPlaying = false
    
    var movie : SunsetMovie?
    
    var tmpMovieURL: NSURL?
    
    var currentShowing: UIView?
    
    var curFilterIndex: Int?
    
    var playerVC: SunsetPlayerViewController?
    

    @IBOutlet weak var subtitleView: UIView!
    
    @IBOutlet weak var filterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var testURL = NSBundle.mainBundle().URLForResource("test", withExtension: "mp4")
        
        movie = SunsetMovie(URL: testURL!)
        
        println("edit movie")
        
        var filter = SunsetFilter(name: "CIPhotoEffectProcess") // CIMotionBlur raise exception
        movie!.addTarget(filter)
        
        for childVC in childViewControllers{
            if let child = childVC as? SunsetPlayerViewController {
                playerVC = child
                playerVC!.delegate = self
            }
            if let child = childVC as? FilterCollectionViewController{
                var filterVC = child
                filterVC.delegate = self
            }
        }
        
        

        
//        var outputFilePath: String = NSTemporaryDirectory().stringByAppendingPathComponent( "tmp".stringByAppendingPathExtension("mp4")!)
//        var movieURL = NSURL(fileURLWithPath: outputFilePath)!
//        var movieWriter = SunsetMovieWriter(newMovieURL: movieURL, newSize: CGSizeMake(640 , 360) )
        
                filter.addTarget(playerVC!.playerView)
        
//        movie!.addTarget(movieWriter)
        
//        movie!.addTarget(playerVC!.playerView )
        
//        movieWriter.startRecording()
        
        movie!.start()
        
        playerVC!.play()
        
        
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
    
    
    
    // MARK: SunsetPlayerViewControllerDelegate
    
    func playBtnClicked(){
        movie!.play()
    }
    
    func pauseBtnClicked(){
        
        movie!.pause()
    }

    
    // MARK: FilterCollectionViewDelegates
    func filterSelected(filterIndex: Int) {
        
        playerVC!.pause()
        movie!.stop()
        
        
        movie!.removeAll()
        
        
        var filter = SunsetFilter(filterIndex: filterIndex)
        movie = SunsetMovie(URL: Utils.getTestVideoUrl())
        
        movie!.addTarget(filter)
        filter.addTarget(playerVC!.playerView)
        
        movie!.start()
        playerVC!.play()
        
    }
    
    
    
    // MARK: UI actions
    @IBAction func maskAction(sender: UIButton) {
        
//        self.upperMask.hidden = !self.upperMask.hidden
//        self.bottomMask.hidden = !self.bottomMask.hidden
//        
        
    }
    
    
    @IBAction func subtitleAction(sender: UIBarButtonItem) {
        
        if self.currentShowing != nil {
            self.currentShowing!.hidden = true
        }
        
        
        if self.currentShowing != self.subtitleView {
            self.subtitleView.hidden = false
            self.currentShowing = self.subtitleView
        }else{
            self.currentShowing = nil
        }
        
        
        
    }
    
    
    @IBAction func filerAction(sender: UIBarButtonItem) {
        
        if self.currentShowing != nil {
            self.currentShowing!.hidden = true
        }
        
        if self.currentShowing != self.filterView {
            self.filterView.hidden = false
            self.currentShowing = self.filterView
        }else{
            self.currentShowing = nil
        }
        
        
    }
}