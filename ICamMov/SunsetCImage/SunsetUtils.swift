//
//  Utils.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/2.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import AVFoundation



class SunsetUtils {
    
    
    class func newPixelBufferFromCGImage(image: CGImage, frameSize: CGSize) -> CVPixelBuffer {
        
        // TODO: define an Umanaged CVPixelBuffer is OK?
        
        var options = [ kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
        //        var options = [
        ////            kCVPixelBufferCGImageCompatibilityKey: NSNumber(bool: true),
        ////            kCVPixelBufferCGBitmapContextCompatibilityKey: NSNumber(bool: true)
        //
        //            kCVPixelBufferCGImageCompatibilityKey as String: NSNumber(bool: true),
        //            kCVPixelBufferCGBitmapContextCompatibilityKey as String : NSNumber(bool: true)
        //        ]
        
        var width = UInt(frameSize.width)
        var height = UInt(frameSize.height)
        
        var pxbuffer : Unmanaged<CVPixelBuffer>?
        
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, OSType(kCVPixelFormatType_32BGRA), options, &pxbuffer)
        
        
        if (status  != kCVReturnSuccess.value || pxbuffer == nil ){
            println("error in CVPixelBufferCreate")
        }

        CVPixelBufferLockBaseAddress(pxbuffer?.takeRetainedValue(), CVOptionFlags.allZeros )
        
        var pxdata:UnsafeMutablePointer<Void> =  CVPixelBufferGetBaseAddress(pxbuffer!.takeRetainedValue())
        if pxdata == nil{
            println("error in CVPixelBufferCreate")
        }

        var rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.NoneSkipFirst.rawValue)
        var context  = CGBitmapContextCreate(pxdata, width, height, 8, 4*width, rgbColorSpace, bitmapInfo)
        

        var frameTransform  = CGAffineTransformIdentity
        CGContextConcatCTM(context, frameTransform)


        CGContextDrawImage(context, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height) ), image)

        CVPixelBufferUnlockBaseAddress(pxbuffer!.takeRetainedValue(), CVOptionFlags.allZeros)
        
        return pxbuffer!.takeRetainedValue()

        
    }
    
    
    class func removeFileIfExist(url: NSURL){
        println("remove url:\(url)")
        if let path = url.path{
            println("remove path: \(path)")
            
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                var error: NSError? = nil
                if NSFileManager.defaultManager().removeItemAtPath(path, error: &error) == false{
                    println("remove item at path \(path) error: \(error) ")
                }
            }
        }
        
    }
    
    
}






//
//- (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image
//{
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//        [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//        [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//        nil];
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
//        frameSize.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
//        &pxbuffer);
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//    
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
//        frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
//        kCGImageAlphaNoneSkipFirst);
//    NSParameterAssert(context);
//    CGContextConcatCTM(context, frameTransform);
//    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
//        CGImageGetHeight(image)), image);
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//    
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//    
//    return pxbuffer;
//}