//
//  EditMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/9.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class EditMovieViewController: UIViewController,  FilterCollectionViewDelegate{
    
    
    var isPlaying = false
    
    var movie : SunsetMovie?
    
    var tmpMovieURL: NSURL?
    
    var currentShowing: UIView?
    
    var curFilterIndex: Int?
    
    var playerVC: SunsetPlayerViewController?
    
    var filter: SunsetFilter?
    
    
    // Set show mask as default
    var maskShowing  = true
    
    

    @IBOutlet weak var subtitleView: UIView!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var topMask: UIView!
    @IBOutlet weak var bottomMask: UIView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        movie = SunsetMovie(URL: Utils.getTestVideoUrl())
        
        println("edit movie")
        
        filter = SunsetFilter(name: "CIPhotoEffectProcess") // CIMotionBlur raise exception
        movie!.addTarget(filter!)
        
        for childVC in childViewControllers{
            if let child = childVC as? SunsetPlayerViewController {
                playerVC = child
            }
            if let child = childVC as? FilterCollectionViewController{
                var filterVC = child
                filterVC.delegate = self
            }
        }
        
        
        
        // Make playerVC assoicate a SunsetMovie to control the playback of it
        playerVC!.associateMovie(movie!)
        
        
        filter!.addTarget(playerVC!.playerView)
        
//        movie!.addTarget(movieWriter)
        
//        movie!.addTarget(playerVC!.playerView )
        
//        movieWriter.startRecording()
        
        
        playerVC!.play()
        

//        var t = Int64( 5 * NSEC_PER_SEC )
//        var stopTime = dispatch_time(DISPATCH_TIME_NOW, t )
        
//        dispatch_after(stopTime, dispatch_get_main_queue(), {
//            
//            movieWriter.finishRecording()
//            self.movie!.pause()
//            println("finish recording")
//        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareMovieSegue" {
            print("toShareMovieSegue: " )

            (segue.destinationViewController as ShareMovieViewController).toShareMovieURL  = Utils.getTestVideoUrl()
            
        }
    }


    
    // MARK: FilterCollectionViewDelegates
    func filterSelected(filterIndex: Int) {
        

        playerVC!.stop()

        movie!.removeAll()
        
        filter!.removeAll()
        
        filter = SunsetFilter(filterIndex: filterIndex)

        
        movie!.addTarget(filter!)
        filter!.addTarget(playerVC!.playerView)

        playerVC!.play()
        
    }
    
    
    
    // MARK: UI actions
    @IBAction func maskAction(sender: UIButton) {
        
        maskShowing = !maskShowing
        
        self.topMask.hidden = !maskShowing
        self.bottomMask.hidden = !maskShowing
        
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