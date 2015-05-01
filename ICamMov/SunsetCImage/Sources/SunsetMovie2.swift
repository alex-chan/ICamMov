//
//  SunsetMovie2.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/23.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class SunsetMovie2: SunsetOutput {
    
    var url: NSURL!
    var asset: AVAsset!
    
    var reader: AVAssetReader?
    
    init(URL: NSURL){
        super.init()
        self.url = URL
    }
    
    override func start() {
        var inputOptions = [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(bool: true)]
        var inputAsset = AVURLAsset(URL: url, options: inputOptions)
        inputAsset.loadValuesAsynchronouslyForKeys(["tracks"], completionHandler: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var error: NSError?
                var tracksStatus = inputAsset.statusOfValueForKey("tracks", error: &error)
                if tracksStatus != AVKeyValueStatus.Loaded {
                    return
                }
                self.asset = inputAsset
                self.processAsset()
            })
            return
        })
    }
    
    func processAsset(){
        reader = self.createAssetReader()
        
    }
    
    func createAssetReader() -> AVAssetReader {
        var error: NSError?
        var assetReader = AVAssetReader(asset: asset, error: &error)
//        var outputSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
//        var readerVideoOuput = AVAssetReaderVideoCompositionOutput(videoTracks: <#[AnyObject]!#>, videoSettings: outputSettings)
        
        return assetReader
    }
    
}