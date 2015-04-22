//
//  EditMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/9.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class Subtitle {
    var time : CMTime!
    var timeSec: Double!
    var chinese: String!
    var english: String!
    
    init(time: CMTime, chinese: String, english: String){
        self.time = time
        self.timeSec = Double( CMTimeGetSeconds(time) )
        self.chinese = chinese
        self.english = english
    }
    
}

class EditMovieViewController: UIViewController,  FilterCollectionViewDelegate{
    
    
    var isPlaying = false
    
    var movie : SunsetMovie?
    
    var tmpMovieURL: NSURL?
    
    var currentShowing: UIView?
    
    var curFilterIndex: Int?
    
    var playerVC: SunsetPlayerViewController!
    
    var filter: SunsetFilter?
    
    var timer: NSTimer!
    
    
    // Set show mask as default
    var maskShowing: Bool  = true {
        didSet {
            self.topMask.hidden = !maskShowing
            self.bottomMask.hidden = !maskShowing
        }
        
    }
    
    var subtitles: [Subtitle] = []
    var subtitleIndex = 0
    

    @IBOutlet weak var subtitleView: UIView!
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var topMask: UIView!
    @IBOutlet weak var bottomMask: UIView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initUI()
        
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
        playerVC.associateMovie(movie!)

        
        var playerView = playerVC.playerView
        filter!.addTarget(playerView)

        
        
//        movie!.addTarget(movieWriter)
        
//        movie!.addTarget(playerVC!.playerView )
        
//        movieWriter.startRecording()
        
        
//        playerVC!.play()
        

//        var t = Int64( 2 * NSEC_PER_SEC )
//        var stopTime = dispatch_time(DISPATCH_TIME_NOW, t )
//        
//        dispatch_after(stopTime, dispatch_get_main_queue(), {
//            playerView.textLayerCh.string = "我想要的未来，是什么"
//            playerView.textLayerEn.string = "What's the future I need "
//            
////            movieWriter.finishRecording()
////            self.movie!.pause()
////            println("finish recording")
//        })
    }
    
    
    func initUI(){
        self.maskShowing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onProgress", userInfo: nil, repeats: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        timer.invalidate()
        
        super.viewWillDisappear(animated)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareMovieSegue" {
            print("toShareMovieSegue: " )

            (segue.destinationViewController as ShareMovieViewController).toShareMovieURL  = Utils.getTestVideoUrl()
            
        }
    }

    // Selectors
    
    func onProgress(){
        
        var subtitleCount =  countElements(self.subtitles)
        
        if subtitleCount == 0 {
            return
        }
        
        
        var sub = self.subtitles[self.subtitleIndex]
        
        if movie!.playedTime >= sub.timeSec && movie!.playedTime <= sub.timeSec+0.2  {
            // show this
            playerVC.playerView.textLayerEn.string = sub.english
            playerVC.playerView.textLayerCh.string = sub.chinese
            
            self.subtitleIndex += 1
        }
        
        if self.subtitleIndex >= subtitleCount  {
            self.subtitleIndex = 0
        }
        
    }


    
    // MARK: FilterCollectionViewDelegates
    func filterSelected(filterIndex: Int) {
        

        playerVC.stop()

        movie!.removeAll()
        
        filter!.removeAll()
        
        filter = SunsetFilter(filterIndex: filterIndex)

        
        movie!.addTarget(filter!)
        filter!.addTarget(playerVC!.playerView)

        playerVC.play()
        
    }
    
    
    
    // MARK: UI actions
    @IBAction func unwindToEditMovie(segue: UIStoryboardSegue) {
        if segue.identifier == "segueDidAddSubtitle" {
            var addSubtitleVC = segue.sourceViewController as AddSubtitleViewController
            var enSubtitle = addSubtitleVC.enSubtitle.text
            var chSubtitle = addSubtitleVC.chSubtitle.text
            
            var enSubtitleArr = split(enSubtitle){$0 == "\n"}
            var chSubtitleArr = split(chSubtitle){$0 == "\n"}
            
            self.subtitles.removeAll(keepCapacity: false)
            self.subtitleIndex = 0
            
            let enCount = countElements(enSubtitleArr)
            for (index,sub) in enumerate(chSubtitleArr) {
                // TODO: the duration is hard coded , which is not good
                var enSub = ""
                if index < enCount {
                    enSub = enSubtitleArr[index]
                }
                var time = CMTimeMakeWithSeconds(Float64(index * 2), 30)
                var newSub = Subtitle(time: time, chinese: sub, english: enSub)
                
                self.subtitles.append(newSub)
            }
//            
//            var sub =  Subtitle(time: CMTimeMakeWithSeconds(Float64(movie!.duration!), 30), chinese:" ", english:" ")
//            
//            self.subtitles.append(sub )
            
            
        }
    }
    
    @IBAction func maskAction(sender: UIButton) {
        
        maskShowing = !maskShowing
        
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