//
//  UserProfileViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/25/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    var user:User? {
        didSet {
            if let user = self.user {
                self.view.layoutIfNeeded()
                if let imageUrl = user.profileImageUrl {
                    self.profileImageView.setImageWithURL(imageUrl)
                }
                if let backgroundUrl = user.backgroundImageUrl {
                    self.backgroundImageView.setImageWithURL(backgroundUrl)
                }
                self.userNameLabel.text = user.name
                self.screenNameLabel.text = user.screenName
                self.userDescriptionLabel.text = user.userDescription
                self.locationLabel.text = user.location
                self.followingCountLabel.text = String(user.followingCount)
                self.followerCountLabel.text = String(user.followerCount)
                self.tweetCountLabel.text = String(user.statusesCount)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = TwitterApp.currentUser
    }
    
}
