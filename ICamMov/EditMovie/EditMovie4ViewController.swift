//
//  EditMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/9.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import AssetsLibrary
import MobileCoreServices

import GPUImage



class EditMovie4ViewController: UIViewController,  FilterCollectionViewDelegate{
    
    
    @IBOutlet weak var moviePreview: GPUImageView!
    var movie2 : GPUImageMovie!
    var player:  AVPlayer!
    var playerItem: AVPlayerItem!
    
    
    // ------
    
    var isPlaying = false
    
    var movie : SunsetMovie!
    
    var toEditMovieURL: NSURL!
    
    var currentShowing: UIView?
    
    var curFilterIndex: Int?
    
    var playerVC: SunsetPlayerViewController!
    
    var filter: SunsetFilter?
    
    var timer: NSTimer!
    
    var movieURLToShare: NSURL!
    
    
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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initUI()
        
        println("edit movie:\(toEditMovieURL)")
        
        
        for childVC in childViewControllers{
            if let child = childVC as? SunsetPlayerViewController {
                playerVC = child
            }
            if let child = childVC as? FilterCollectionViewController{
                var filterVC = child
                filterVC.delegate = self
            }
        }
        
        
        
        
    }
    
    
    func initUI(){
        self.maskShowing = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        playerItem = AVPlayerItem(URL: toEditMovieURL)
        player = AVPlayer(playerItem: playerItem)
        
        
        movie2 = GPUImageMovie(playerItem: playerItem)
        movie2.playAtActualSpeed = true
        movie2.addTarget(self.moviePreview)
        
        player.play()
        movie2.startProcessing()
    }
    //    override func viewWillAppear(animated: Bool) {
    //        self.activityIndicator.stopAnimating()
    //
    //        movie = SunsetMovie(URL: toEditMovieURL)
    //
    //        filter = SunsetFilter(name: "CIPhotoEffectProcess") // CIMotionBlur raise exception
    //        movie.addTarget(filter!)
    //
    //
    //        // Make playerVC assoicate a SunsetMovie to control the playback of it
    //        playerVC.associateMovie(movie)
    //
    //        var playerView = playerVC.playerView
    //        filter!.addTarget(playerView)
    ////        playerVC!.play()
    //
    //        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onProgress", userInfo: nil, repeats: true)
    //        super.viewWillAppear(animated)
    //    }
    //
    //    override func viewWillDisappear(animated: Bool) {
    //
    //        timer.invalidate()
    //
    //        super.viewWillDisappear(animated)
    //    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareMovieSegue" {
            print("toShareMovieSegue: " )
            if let url = movieURLToShare{
                (segue.destinationViewController as ShareMovieViewController).toShareMovieURL  = url
            }
            
            
            
        }
    }
    
    // Selectors
    
    func onProgress(){
        
        var subtitleCount =  countElements(self.subtitles)
        
        if subtitleCount == 0 {
            return
        }
        
        
        var sub = self.subtitles[self.subtitleIndex]
        
        if movie.playedTime >= sub.timeSec && movie.playedTime <= sub.timeSec+0.2  {
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
        
        movie.removeAll()
        
        filter!.removeAll()
        
        filter = SunsetFilter(filterIndex: filterIndex)
        
        
        movie.addTarget(filter!)
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
            //            var sub =  Subtitle(time: CMTimeMakeWithSeconds(Float64(movie.duration!), 30), chinese:" ", english:" ")
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
    @IBAction func showShareScene(sender: AnyObject) {
        
        self.activityIndicator.startAnimating()
        
        var movie2 = GPUImageMovie(URL: toEditMovieURL)
        
        
        var  kDateFormatter: NSDateFormatter?
        kDateFormatter = NSDateFormatter()
        kDateFormatter!.dateStyle = NSDateFormatterStyle.MediumStyle
        kDateFormatter!.timeStyle = NSDateFormatterStyle.ShortStyle
        var outurl = NSFileManager.defaultManager()
            .URLForDirectory(
                .DocumentDirectory,
                inDomain: .UserDomainMask,
                appropriateForURL: nil,
                create: true,
                error: nil)!
            .URLByAppendingPathComponent(kDateFormatter!.stringFromDate( NSDate() ) )
            .URLByAppendingPathExtension( UTTypeCopyPreferredTagWithClass( AVFileTypeQuickTimeMovie , kUTTagClassFilenameExtension).takeRetainedValue() )
        
        
        var movie2writer = GPUImageMovieWriter(movieURL: outurl, size: movie.movieSize)
        movie2.addTarget(movie2writer)
        movie2writer.completionBlock = {
            self.activityIndicator.stopAnimating()
            self.movieURLToShare = outurl
            
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("toShareMovieSegue", sender: nil)
            })
        }
        
        movie2writer.startRecording()
        movie2.startProcessing()
        
    }
}