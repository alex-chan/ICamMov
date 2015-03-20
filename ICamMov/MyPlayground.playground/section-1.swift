// Playground - noun: a place where people can play

import UIKit
import AVOSCloud


println("test2")

AVOSCloud.setApplicationId("xkjj8zwzxiyouqo4m3war047dy40nfw0axxr10s0d85e6a9d", clientKey: "20toct9i8jnyl7eperpl7o66puy9s2bzr70h2dq0rkoqvgt7")

println("test2")

var result = AVCloud.callFunction("refreshVideos", withParameters:nil)
println(result)


println("test")

