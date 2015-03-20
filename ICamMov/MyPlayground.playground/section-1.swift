// Playground - noun: a place where people can play

import UIKit
import AVOSCloud






AVCloud.callFunctionInBackground("hello", withParameters: nil, block: {
    (result: AnyObject!, error: NSError!) in
    println(result)
    return
    
})
