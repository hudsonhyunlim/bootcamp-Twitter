//
//  TweetEditViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class TweetEditViewController: UIViewController {


    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetEditTextView: UITextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
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
        
        self.tweetEditTextView.becomeFirstResponder()
    }
    
    @IBAction func onPost(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(
            true,
            completion: nil)
    }
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(
            true,
            completion: nil)
    }
    
}

extension TweetEditViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        if let text = textView.text {
            if text.characters.count > 140 {
                self.postButton.tintColor = UIColor.grayColor()
            } else {
                self.postButton.tintColor = UIColor.blueColor()
            }
        }
    }
    
}