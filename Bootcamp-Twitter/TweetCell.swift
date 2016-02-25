//
//  TweetCell.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var sinceLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            if let image = tweet?.userProfileImage {
                print(image)
                self.profileImageView.setImageWithURL(image)
            }
            if let userName = tweet?.userName {
                self.userNameLabel.text = userName
            }
            if let screenName = tweet?.screenName {
                self.screenNameLabel.text = screenName
            }
            if let tweetText = tweet?.text {
                self.tweetLabel.text = tweetText
            }
            if let relative = tweet?.getAutoRelativeCreatedAt() {
                self.sinceLabel.text = relative
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true
    }

}
