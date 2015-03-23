//
//  VideoMasterCell.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/23.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class VideoMasterCell: UITableViewCell {
    
    @IBOutlet weak var avatar: AvatarImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var postTime: UILabel!
    
    @IBOutlet weak var videoContent: MoviePreviewView!
    

    
}