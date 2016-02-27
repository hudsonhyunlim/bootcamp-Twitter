//
//  MenuViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/25/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    private enum ViewControllerNames: String {
        case Tweets = "com.lyft.TweetsNavigationController"
        case Profile = "com.lyft.UserProfileNavigationController"
        case Mentions = "foobar"
    }
    
    private var viewControllers: [ViewControllerNames: UIViewController] = [:]
    
    private let menuItems:[[String:String]] = [
        [
            "name": "Home",
            "imageName": "home",
        ],
        [
            "name": "Profile",
            "imageName": "user"
        ],
        [
            "name": "Mentions",
            "imageName": "warning"
        ],
    ]
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeNavigationController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Tweets.rawValue)
        let profileNavigationController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Profile.rawValue)
        let mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Tweets.rawValue)
        
        if let homeNavigationController = homeNavigationController as? UINavigationController,
           let homeController = homeNavigationController.topViewController as? TweetsViewController {
            homeController.tweetListType = TwitterApp.TweetListType.Home
        }
        
        if let mentionsNavigationController = mentionsNavigationController as? UINavigationController,
           let mentionsController = mentionsNavigationController.topViewController as? TweetsViewController {
            mentionsController.tweetListType = TwitterApp.TweetListType.Mentions
        }
        
        viewControllers[ViewControllerNames.Tweets] = homeNavigationController
        viewControllers[ViewControllerNames.Profile] = profileNavigationController
        viewControllers[ViewControllerNames.Mentions] = mentionsNavigationController
        
        hamburgerViewController?.contentViewController = homeNavigationController
        
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        self.menuTableView.estimatedRowHeight = 120
        self.menuTableView.reloadData()
    }

}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.MenuCell", forIndexPath: indexPath) as! MenuCell
        
        cell.menuConf = self.menuItems[indexPath.row]
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            self.hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Tweets]
        case 1:
            if let profileNavigationController = viewControllers[ViewControllerNames.Profile] as? UINavigationController,
                let profileController = profileNavigationController.topViewController as? UserProfileViewController {
                    
                profileController.user = TwitterApp.currentUser
                profileController.dismissable = false
                    
                self.hamburgerViewController?.contentViewController = profileNavigationController
            }
        case 2:
            self.hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Mentions]
        default:
            break
        }
        self.hamburgerViewController?.moveContentDrawer(false)
    }
    
}