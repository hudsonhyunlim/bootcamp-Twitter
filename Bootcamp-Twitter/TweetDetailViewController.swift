//
//  TweetDetailViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    weak var tweet:Tweet? {
        didSet {
            
        }
    }
    
    @IBAction func onHomeTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
