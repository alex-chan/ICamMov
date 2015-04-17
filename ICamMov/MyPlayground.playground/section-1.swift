
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

var size = CGSizeMake(300, 200)

println(size)






println( CGRectMake(0, 0, 300, 200) / 2.0 )

