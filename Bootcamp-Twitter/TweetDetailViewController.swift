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
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet:Tweet? {
        didSet {
            if self.profileImageView != nil {
                self.mapTweetToUI()
            }
        }
    }
    
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
            
            if let favorited = tweet.favorited {
                self.setFavoriteButton(favorited)
            }
        }
    }

    @IBAction func onReplyTouch(sender: UIButton) {
    }
    
    @IBAction func onRetweetTouch(sender: UIButton) {
    }
    
    @IBAction func onFavoriteTouch(sender: UIButton) {
        let client = TwitterClient.getInstance()
        
        if client.postInFlight {
            return
        }
        
        if let tweet = self.tweet,
           let favorited = tweet.favorited,
           let idStr = tweet.idStr {
            self.setFavoriteButton(!favorited)
            if favorited {
                client.favoriteDestroy(
                    idStr,
                    success: { (tweet: Tweet) -> Void in
                        self.tweet = tweet
                    },
                    failure: { (error: NSError?) -> Void in
                        print(error)
                })
            } else {
                client.favoriteCreate(
                    idStr,
                    success: { (tweet: Tweet) -> Void in
                        self.tweet = tweet
                    },
                    failure: { (error: NSError?) -> Void in
                        print(error)
                })
            }
        }
    }
    
    private func setFavoriteButton(favorited: Bool) {
        let favoriteImage = favorited ? TwitterApp.favoriteOn : TwitterApp.favoriteOff
        self.favoriteButton.setBackgroundImage(favoriteImage, forState: UIControlState.Normal)
    }
}
