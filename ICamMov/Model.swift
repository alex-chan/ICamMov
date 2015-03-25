//
//  Model.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/23.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


func basicACL() -> AVACL! {
    var acl = AVACL()
    acl.setPublicReadAccess(true)
    acl.setPublicWriteAccess(false)
    acl.setWriteAccess(true, forUser: AVUser.currentUser())
    return acl
}

class LPVideo: AVObject, AVSubclassing {
    
    
    class func parseClassName() -> String! {
        return "Video"
    }
    


    @NSManaged var videoFile: AVFile?
    @NSManaged var owner: AVUser?
    @NSManaged var coverImage: AVFile?
    var createdAtCopy : String?
    var updatedAtCopy : String?
    var likes: Int = 0
    
        
}

class LPComment: AVObject, AVSubclassing {
    class func parseClassName() -> String! {
        return "Comment"
    }
    
    var commentAtVideo: LPVideo?
    var commentWhen: NSDate?
    var replyToUser: AVUser?
}




// TODO: Use this class instead of AVUser
class LPUser: AVUser, AVSubclassing {
    class func parseClassName() -> String! {
        return "_User"
    }

        
    var nickname: String?
    var avatar: String?
    var avatarFile : AVFile?  // avatar avatarFile is duplicated with avatar, need avatar?
    
//    override var ACL: AVACL! = mainACL()
    
    
    
}