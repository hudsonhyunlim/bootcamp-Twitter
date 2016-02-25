//
//  HamburgerViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/25/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var menuViewController: MenuViewController? {
        didSet {
            if let menuViewController = self.menuViewController {
                self.view.layoutIfNeeded()
                self.menuView.addSubview(menuViewController.view)
            }
        }
    }
    
    var contentViewController: UIViewController? {
        didSet {
            if let contentViewController = self.contentViewController {
                self.view.layoutIfNeeded()
                self.contentView.addSubview(contentViewController.view)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Hamburger viewDidLoad")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let menuViewController = storyboard.instantiateViewControllerWithIdentifier("com.lyft.MenuViewController") as? MenuViewController {
            
            menuViewController.hamburgerViewController = self
            self.menuViewController = menuViewController
        }
    }
    
}
