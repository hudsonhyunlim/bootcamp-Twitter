//
//  TweetDetailViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

protocol TweetDetailViewControllerDelegate {
    
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweetDidChange tweet: Tweet)
    
}

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
    
    var delegate: TweetDetailViewControllerDelegate?
    
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
            self.createdAtLabel.text = tweet.getReadableCreatedAt()
            
            if let favorited = tweet.favorited {
                self.setFavoriteButton(favorited)
            }
            
            if let retweeted = tweet.retweeted {
                self.setRetweetButton(retweeted)
            }
        }
    }

    @IBAction func onReplyTouch(sender: UIButton) {
    }
    
    @IBAction func onRetweetTouch(sender: UIButton) {
        let client = TwitterClient.getInstance()
        
        if client.postInFlight {
            return
        }
        
        if let tweet = self.tweet,
           let retweeted = tweet.retweeted,
           let idStr = tweet.idStr {
            self.setRetweetButton(!retweeted)
            if retweeted {
                client.unretweet(
                    idStr,
                    success: { (tweet: Tweet) -> Void in
                        self.tweet?.retweeted = false
                        self.delegate?.tweetDetailViewController(self, tweetDidChange: self.tweet!)
                    },
                    failure: { (error: NSError?) -> Void in
                        print(error)
                })
            } else {
                client.retweet(
                    idStr,
                    success: { (tweet: Tweet) -> Void in
                        self.tweet?.retweeted = true
                        self.delegate?.tweetDetailViewController(self, tweetDidChange: self.tweet!)
                    },
                    failure: { (error: NSError?) -> Void in
                        print(error)
                })
            }
        }
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
                        self.delegate?.tweetDetailViewController(self, tweetDidChange: tweet)
                    },
                    failure: { (error: NSError?) -> Void in
                        print(error)
                })
            } else {
                client.favoriteCreate(
                    idStr,
                    success: { (tweet: Tweet) -> Void in
                        self.tweet = tweet
                        self.delegate?.tweetDetailViewController(self, tweetDidChange: tweet)
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
    
    private func setRetweetButton(retweeted: Bool) {
        let retweetImage = retweeted ? TwitterApp.retweetOn : TwitterApp.retweetOff
        self.retweetButton.setBackgroundImage(retweetImage, forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "com.lyft.segueFromDetailsToEdit" {
            if let navVc = segue.destinationViewController as? UINavigationController,
                let vc = navVc.topViewController as? TweetEditViewController {
                    vc.delegate = self
            }
        }
    }
}

extension TweetDetailViewController: TweetEditViewControllerDelegate {
    
    func tweetEditViewController(tweetEditViewController: TweetEditViewController, inReplyTo tweet: Tweet?) -> Tweet? {
        return self.tweet
    }
    
}
