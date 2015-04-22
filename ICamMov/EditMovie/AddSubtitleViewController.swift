//
//  AddSubtitleViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/22.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class AddSubtitleViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var chSubtitle: UITextView!
    @IBOutlet weak var enSubtitle: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchSubtitleFromServer()
    }
    
    override func viewDidLayoutSubviews() {
        let scrollViewBounds = scrollView.bounds
        let contentViewBounds = contentView.bounds

        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = scrollViewBounds.size.height - contentViewBounds.size.height + 1
    }
    
    
    @IBAction func fetchSubtitle(sender: AnyObject) {
        
        self.fetchSubtitleFromServer()
    }
    // MARK: Custom functions
    func fetchSubtitleFromServer(){
        println("fetch subtitle from server")
        
//        AVCloud.callFunctionInBackground("fetchRandomSubtitle", withParameters: nil, target: self, selector: "subtitleFetched:error")
        
        AVCloud.callFunctionInBackground("fetchRandomSubtitle", withParameters: nil, block: {
            (result, error) in
        
            println(result)
            if error != nil {
                println(error.localizedDescription)
                Utils.alert(message: error.localizedDescription)
                return
            }
            if let res = result as? [String: AnyObject] {
                self.chSubtitle.text = res["chinese"] as String
                self.enSubtitle.text = res["english"] as String
            }

            
        })
    }
    
    // MARK: Selectors
    
    func subtitleFetched(result: AnyObject!, error: NSError! ){
        println("subtitle fetched")
        if error == nil {
            println(error.localizedDescription)
            Utils.alert(message: error.localizedDescription)
            return
        }
        
        println(result)
        
    }
}