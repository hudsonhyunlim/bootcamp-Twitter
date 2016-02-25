//
//  MenuViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/25/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private enum ViewControllerNames: String {
        case Tweets = "com.lyft.TweetsNavigationController"
    }
    
    private var viewControllers: [ViewControllerNames: UIViewController] = [:]
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewControllers[ViewControllerNames.Tweets] = storyboard.instantiateViewControllerWithIdentifier(ViewControllerNames.Tweets.rawValue)
        
        hamburgerViewController?.contentViewController = viewControllers[ViewControllerNames.Tweets]
    }

}
