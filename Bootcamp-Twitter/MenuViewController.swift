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
        case Home = "com.lyft.TweetsNavigationController"
        case Profile = "com.lyft.UserProfileNavigationController"
    }
    
    private var viewControllers: [ViewControllerNames: UIViewController] = [:]
    
    private let menuItems:[String] = [
        "Home",
        "Profile",
        "Mentions",
    ]
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewControllers[ViewControllerNames.Home] = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Home.rawValue)
        viewControllers[ViewControllerNames.Profile] = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Profile.rawValue)
        
        hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Home]
        
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
        
        cell.nameLabel.text = self.menuItems[indexPath.row]
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            self.hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Home]
        case 1:
            self.hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Profile]
        default:
            break
        }
        self.hamburgerViewController?.moveContentDrawer(false)
    }
    
}