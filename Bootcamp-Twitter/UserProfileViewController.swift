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
    
    var user:User? {
        didSet {
            if let user = self.user {
                if let imageUrl = user.profileImageUrl {
                    self.profileImageView.setImageWithURL(imageUrl)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = TwitterApp.currentUser
    }
    
}
