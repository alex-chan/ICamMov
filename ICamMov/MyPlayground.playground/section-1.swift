
import UIKit
import Foundation

extension UIColor {
     class func appGlobalColor() -> UIColor {
        return UIColor(red: 0.349, green: 0.863, blue: 0.78, alpha: 1)
    }
    
    func test() -> UIColor{
        println("test")
        return UIColor.blueColor()
    }
}

UIColor.appGlobalColor()



var t : UIColor?

t?.test().description


let filterList = ["CIPhotoEffectChrome",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectMono",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CIPhotoEffectTransfer"]

import AVFoundation

var time = CMTimeMake(50,30)

var s = CMTimeGetSeconds(time)

println(s)
println( Int(s) )
round(s)





