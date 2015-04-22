//
//  SunsetView.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import UIKit

class SunsetLayer: CALayer {
    
    override init!() {
        super.init()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}

class SunsetView: UIView, SunsetInputDelegate {
    
    
    enum FillType{
        case StretchFill
        case KeepRatioFill
        case KeepRatio
    }
    
    
    var duration : CGFloat?
    
    
    var fillMode: String  = kCAGravityResizeAspect
    var videoSize: CGSize?
    
    
    var videoLayer: CALayer = CALayer()
    var backgroundLayer: CALayer = CALayer()
    
    var textLayerCh: CATextLayer!
    var textLayerEn: CATextLayer!
    
    let MASK_HEIGHT: CGFloat = 20.0
    let FONT_SIZE: CGFloat = 11.0
    let TEXTLAYER_HEIGHT : CGFloat =  12.0
    
    var borderHeight: CGFloat  = 0.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setupLayer()
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setupLayer()
        
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        println("layoutSubviews")
        println("videoLayerFrame:\(self.videoLayer.frame), bounds: \(self.videoLayer.bounds)")
        println("layerFrame:\(self.layer.frame), bounds: \(self.layer.bounds)")
        println("frame:\(self.frame), bounds:\(self.bounds)")
        
        println("scale:\(UIScreen.mainScreen().scale)")
        println("layerScale:\(self.layer.contentsScale)")
        
        
        
        videoLayer.contentsScale = UIScreen.mainScreen().scale
        videoLayer.frame = CGRectMake(0, borderHeight, layer.bounds.size.width, layer.bounds.size.height-borderHeight*2)
        videoLayer.contentsGravity = kCAGravityResize
        

        self.layoutTextLayer()

        
    }
    
    var bgImg: UIImage?
    
    func initTextLayer(type: String) -> CATextLayer{
        var textLayer = CATextLayer()
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.font = "Helvetica"
        textLayer.fontSize = FONT_SIZE
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.foregroundColor = UIColor.whiteColor().CGColor
        if type == "en" {
            textLayer.string = "请添加字幕"

        }else{
            textLayer.string = "Please add subtitle"

        }
        
        return textLayer
    }
    
    func layoutTextLayer(){
        let layerSize = layer.bounds.size
        textLayerCh.frame = CGRectMake(0, layerSize.height - TEXTLAYER_HEIGHT * 2 - MASK_HEIGHT, layerSize.width, TEXTLAYER_HEIGHT)
        textLayerEn.frame = CGRectMake(0, layerSize.height - TEXTLAYER_HEIGHT  - MASK_HEIGHT, layerSize.width, TEXTLAYER_HEIGHT)
   
    }
    
    func setupLayer(){
        
        self.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        println("videoLayerFrame:\(self.videoLayer.frame), bounds: \(self.videoLayer.bounds)")
        println("layerFrame:\(self.layer.frame), bounds: \(self.layer.bounds)")
        println("frame:\(self.frame), bounds:\(self.bounds)")
        
        println("scale:\(UIScreen.mainScreen().scale)")
        println("layerScale:\(self.layer.contentsScale)")
        
        videoLayer.contentsScale = UIScreen.mainScreen().scale
        videoLayer.contentsGravity = kCAGravityResize
//        self.layer.contentsGravity = kCAGravityResizeAspect
//        self.layer.masksToBounds = true
        self.layer.addSublayer(videoLayer)
        self.layer.masksToBounds = true
        
        textLayerCh = self.initTextLayer("ch")
        textLayerEn = self.initTextLayer("en")
        
        self.layoutTextLayer()
        
        self.layer.insertSublayer(textLayerCh, above: videoLayer)
        self.layer.insertSublayer(textLayerEn, above: videoLayer)
        
        
        

    }
    

    
    func imageWithColor(color: UIColor, imageSize: CGRect) -> UIImage {

        var rect = imageSize
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        return image
        
    }

    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) {
        
        var ciImage =  CIImage(CVPixelBuffer: pixelBuffer)
        var tempContext = CIContext(options: nil)
        
        var width = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        var height =  CGFloat( CVPixelBufferGetHeight(pixelBuffer) )
        
        
        var size = self.frame.size
        
        println("processMovieFrame, height:\(height), width:\(width)")
        
        
        var videoImage = tempContext.createCGImage(ciImage, fromRect: CGRectMake(0, 0, width, height))

        self.dispatchCGImage(videoImage)


    }
    
    
    
    func processAudioData(sampleBuffer: CMSampleBuffer) {
        // TODO: XXX
    }
    
    func dispatchCGImage(cgImage: CGImage){
        
//        println("dispatchCGImage")

        self.videoLayer.contents = cgImage
        
//        self.layer.contents = cgImage
        
//        self.videoLayer.contentsGravity = kCAGravityResize
        
//        self.layer.contentsGravity = fillMode
        
    }

    
    
    func setMovieSize(size: CGSize){
        self.videoSize = size
    }
    
    
    
}