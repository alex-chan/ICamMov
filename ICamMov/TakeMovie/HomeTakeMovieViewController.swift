//
//  HomeTakeMovieViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/29.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import AssetsLibrary
import MobileCoreServices

import GPUImage



enum MovieType: Int {
    case Normal
    case Cinema
}


class HomeTakeMovieViewController: UIViewController{
    
    
    @IBOutlet var preview: GPUImageView!
    @IBOutlet var rootBlur: GPUImageView!
    @IBOutlet weak var recordStopBtn: UIButton!
    
    
    var videoCamera: GPUImageVideoCamera!
    var videoWriter: GPUImageMovieWriter!
    var cropFilter: GPUImageCropFilter!
    var outURL: NSURL!
    var movieType : MovieType = .Normal
    var movieSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .Front)
        
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        preview.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        
        
        videoCamera.addTarget(preview)
        
//        var gaussianFilter = GPUImageGaussianBlurFilter()
//        gaussianFilter.blurRadiusInPixels = 50.0
//        
//        videoCamera.addTarget(gaussianFilter)
//        gaussianFilter.addTarget(rootBlur)
        
        
        
        videoCamera.addAudioInputsAndOutputs()
        
        videoCamera.startCameraCapture()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.recordStopBtn.selected = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        return ( orientation == .LandscapeLeft || orientation == .LandscapeRight)
    }
    
    override func shouldAutorotate() -> Bool {
        return !recordStopBtn.selected
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        // ref: http://stackoverflow.com/questions/26069874/what-is-the-right-way-to-handle-orientation-changes-in-ios-8
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        

        var orientation = UIApplication.sharedApplication().statusBarOrientation

        println("orientation:\(orientation.rawValue)")
        
        coordinator.animateAlongsideTransition({
            (context: UIViewControllerTransitionCoordinatorContext!) in

            
            var orientation = UIApplication.sharedApplication().statusBarOrientation
    
            println("orientation:\(orientation.rawValue)")
            self.videoCamera.outputImageOrientation = orientation
            
            if orientation  == .LandscapeLeft || orientation == .LandscapeRight {
                self.movieType = .Cinema
            }else{
                self.movieType = .Normal
            }
                        
            
            }, completion: nil)

        
       
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEditMovieSegue2" {
            var vc = segue.destinationViewController as EditMovieViewController
            vc.toEditMovieURL = outURL
            vc.toEditMovieType = movieType
            vc.toEditMovieSize = movieSize
            
            
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func unwindToHomeTakeMovie(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func recordOrStop(sender: UIButton) {
        self.recordStopBtn.selected = !self.recordStopBtn.selected
        var isRecord: Bool =  self.recordStopBtn.selected
        
        if isRecord {
//            var outurl = NSFileManager.defaultManager()
//                .URLForDirectory(
//                    .DocumentDirectory,
//                    inDomain: .UserDomainMask,
//                    appropriateForURL: nil,
//                    create: true,
//                    error: nil)!
//                .URLByAppendingPathExtension( UTTypeCopyPreferredTagWithClass( AVFileTypeQuickTimeMovie , kUTTagClassFilenameExtension).takeRetainedValue() )
//            if (NSFileManager.defaultManager().fileExistsAtPath(outurl.path!) ) {
//                var error: NSError?
//                if NSFileManager.defaultManager().removeItemAtPath(outurl.path!, error: &error) == false {
//                    println("Remove item at path \(outurl.path!) error:\(error)" )
//                }
//                
//            }
            
            var path = NSTemporaryDirectory().stringByAppendingPathComponent("tmp".stringByAppendingPathExtension("mov")!)
            var url = NSURL(fileURLWithPath: path)
            if NSFileManager.defaultManager().fileExistsAtPath(path){
                var error:NSError?
                if NSFileManager.defaultManager().removeItemAtPath(path, error: &error) == false {
                    println("remove item at path \(path) failed: \(error!.localizedDescription)")
                }
            }
            
            
            outURL = url
            
            var view = self.preview as GPUImageView
            
            println("size:\(view.bounds.size)")
            
            var size = self.getCaptureVideoSize()
            var destRect: CGRect!
            var kAspect: CGFloat!
            if movieType == .Normal {
                kAspect = 3 / 4
            }else{
                kAspect = 9 / 16
            }
            
            var movieAspect = size.height / size.width
            
            if movieAspect < kAspect {
                destRect = CGRectMake( (kAspect-movieAspect)/kAspect/2 , 0, movieAspect/kAspect, 1)
                destRect = CGRectMake(0, 0, movieAspect/kAspect, 1)
            }else{
                destRect = CGRectMake(0, (movieAspect-kAspect)/movieAspect/2, 1, kAspect/movieAspect)
//                destRect = CGRectMake(0, 0, 1, kAspect/movieAspect)
            }
            
//            if size.width * kAspect > size.height  {
//                let colPadding = ( size.width - size.height / kAspect ) / 2
//                destRect = CGRectMake( colPadding / size.width, 0, size.height / kAspect / size.width, 1)
//            }else{
//                let rowPadding = ( size.height - size.width * kAspect ) / 2
//                destRect = CGRectMake( 0, rowPadding / size.height  , 1  , size.width * kAspect / size.height)
//            }
            

            
            movieSize = CGSizeMake(destRect.size.width * size.width, destRect.size.height * size.height)
     
            
            cropFilter = GPUImageCropFilter(cropRegion: destRect)
            
            videoWriter = GPUImageMovieWriter(movieURL: url, size: movieSize)
            
            videoCamera.addTarget(cropFilter)
            
            cropFilter.addTarget(videoWriter)
 
            videoWriter.encodingLiveVideo = true
            
            videoCamera.audioEncodingTarget = videoWriter

            videoWriter.startRecordingInOrientation(CGAffineTransformMakeRotation(0))

        }else{
            videoWriter.finishRecordingWithCompletionHandler({
                self.performSegueWithIdentifier("toEditMovieSegue2", sender: self)
            })
            
        }
        
    }
    

    // MARK: Custom functions
    func getCaptureVideoSize() -> CGSize{
        
        var outputSettings: [NSObject: AnyObject]?
        
        for output in self.videoCamera.captureSession.outputs {
            if let out = output as? AVCaptureVideoDataOutput {
                outputSettings = out.videoSettings
            }
        }
        
        if outputSettings == nil {
            return CGSizeMake(0, 0)
        }
        
        
        var width = CGFloat(outputSettings!["Width"]!.doubleValue)
        var height = CGFloat(outputSettings!["Height"]!.doubleValue)
        
        if UIInterfaceOrientationIsPortrait(self.videoCamera.outputImageOrientation){
            var tmp = width
            width = height
            height = tmp
        }
        
        return CGSizeMake(width, height)
        
    }
    
}