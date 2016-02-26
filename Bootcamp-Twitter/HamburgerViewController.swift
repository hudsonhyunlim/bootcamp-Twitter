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
    
    @IBOutlet weak var contentViewLeading: NSLayoutConstraint!
    var originalContentCenter:CGPoint?
    
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
                contentViewController.willMoveToParentViewController(self)
                self.contentView.addSubview(contentViewController.view)
                contentViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let menuViewController = storyboard.instantiateViewControllerWithIdentifier("com.lyft.MenuViewController") as? MenuViewController {
            
            menuViewController.hamburgerViewController = self
            self.menuViewController = menuViewController
        }
    }
    
    @IBAction func onContentPan(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translate = sender.translationInView(self.view)
        let velocity = sender.velocityInView(self.view)
        let maxX = (self.contentView.bounds.width * 1.5) - 50
        let minX = self.contentView.bounds.width / 2
        
        switch (state) {
        case UIGestureRecognizerState.Began:
            self.originalContentCenter = self.contentView.center
        case UIGestureRecognizerState.Changed:
            if let originalContentCenter = self.originalContentCenter {
                let offset = originalContentCenter.x + translate.x
                if offset > minX && offset < maxX {
                    self.contentView.center = CGPoint(
                        x: offset,
                        y: originalContentCenter.y)
                }
            }
        case UIGestureRecognizerState.Ended:
            UIView.animateWithDuration(
                0.2,
                delay: 0.0,
                options: [],
                animations: { () -> Void in
                    if let originalContentCenter = self.originalContentCenter {
                        if velocity.x > 0 {
                            self.contentView.center = CGPoint(
                                x: maxX,
                                y: originalContentCenter.y)
                        } else {
                            self.contentView.center = CGPoint(
                                x: minX,
                                y: originalContentCenter.y)
                        }
                        self.view.layoutIfNeeded()
                    }
                },
                completion: nil)
        default:
            break
        }
    }
}
