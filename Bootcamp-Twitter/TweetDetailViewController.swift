//
//  TweetDetailViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    weak var tweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapTweetToUI()
    }
    
    @IBAction func onHomeTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func mapTweetToUI() {
        if let tweet = self.tweet {
            if let profileImage = tweet.userProfileImage {
                self.profileImageView.setImageWithURL(profileImage)
            }
            self.userNameLabel.text = tweet.userName
            self.screenNameLabel.text = tweet.screenName
            self.tweetTextLabel.text = tweet.text
            self.retweetCountLabel.text = String(tweet.retweetCount)
            self.favoritesCountLabel.text = String(tweet.favoritesCount)
        }
    }

}
