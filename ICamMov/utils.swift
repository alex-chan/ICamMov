//
//  utils.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/11.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class Utils {

    class func copyImageFromVideo(videoURL: NSURL, atTime: CMTime ) -> CGImage{
        
        
        var actualTime = CMTimeMake(0,0)
        var error: NSError?
        
        var asset = AVAsset.assetWithURL(videoURL) as AVAsset
        var imageGen = AVAssetImageGenerator(asset: asset)
        
        var cgImage = imageGen.copyCGImageAtTime(atTime, actualTime: &actualTime, error: &error) as CGImage
        
        return cgImage
        
        
    }
}