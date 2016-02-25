//
//  TweetEditViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

protocol TweetEditViewControllerDelegate {
    func tweetEditViewController(tweetEditViewController: TweetEditViewController, didPostTweet tweet: Tweet)
}

class TweetEditViewController: UIViewController {


    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var tweetEditTextView: UITextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var delegate: TweetEditViewControllerDelegate?
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = TwitterApp.currentUser
        if let user = self.user {
            self.userNameLabel.text = user.name
            self.screenNameLabel.text = user.screenName
            if let photoUrl = user.profileImageUrl {
                self.userProfileImage.setImageWithURL(photoUrl)
            }
        }
        
        self.tweetEditTextView.delegate = self
        
        self.handleUniversalChange()
        
        self.tweetEditTextView.becomeFirstResponder()
    }
    
    @IBAction func onPost(sender: UIBarButtonItem) {
        if let text = self.tweetEditTextView.text {
            if text.characters.count <= Tweet.CHARACTER_LIMIT {
                TwitterClient.getInstance().updateStatus(
                    text,
                    inReplyToStatusId: nil,
                    success: { (tweet: Tweet) -> Void in
                        print("tweeted successfully")
                        print(tweet.idStr)
                        self.delegate?.tweetEditViewController(self, didPostTweet: tweet)
                        self.dismissViewControllerAnimated(
                            true,
                            completion: nil)
                    },
                    failure: { (error: NSError?) -> Void in
                        if let error = error {
                            print("tweet failed")
                            print(error)
                        }
                })
            } else {
                print("character limit")
            }
        }
    }
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(
            true,
            completion: nil)
    }
    
    private func handleUniversalChange() {
        if let text = self.tweetEditTextView.text {
            let count = text.characters.count
            if count > Tweet.CHARACTER_LIMIT {
                self.postButton.tintColor = UIColor.grayColor()
                self.charactersLabel.textColor = UIColor.redColor()
            } else {
                self.postButton.tintColor = UIColor.blueColor()
                self.charactersLabel.textColor = UIColor.grayColor()
            }
            self.charactersLabel.text = String(Tweet.CHARACTER_LIMIT - count)
        }
    }
    
}

extension TweetEditViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        self.handleUniversalChange()
    }
    
}