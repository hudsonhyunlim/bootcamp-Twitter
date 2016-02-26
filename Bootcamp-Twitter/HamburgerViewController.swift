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
    var maxX:CGFloat = 0
    var minX:CGFloat = 0
    
    var menuViewController: MenuViewController? {
        didSet (oldMenuViewController) {
            if let menuViewController = self.menuViewController {
                self.view.layoutIfNeeded()
                
                if oldMenuViewController != nil {
                    oldMenuViewController?.willMoveToParentViewController(nil)
                    oldMenuViewController?.view.removeFromSuperview()
                    oldMenuViewController?.didMoveToParentViewController(nil)
                }
                
                menuViewController.willMoveToParentViewController(self)
                self.menuView.addSubview(menuViewController.view)
                menuViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    var contentViewController: UIViewController? {
        didSet (oldContentViewController) {
            if let contentViewController = self.contentViewController {
                self.view.layoutIfNeeded()
                
                if oldContentViewController != nil {
                    oldContentViewController?.willMoveToParentViewController(nil)
                    oldContentViewController?.view.removeFromSuperview()
                    oldContentViewController?.didMoveToParentViewController(nil)
                }
                
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.maxX = (self.contentView.bounds.width * 1.5) - 50
        self.minX = self.contentView.bounds.width / 2
    }
    
    @IBAction func onContentPan(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let translate = sender.translationInView(self.view)
        let velocity = sender.velocityInView(self.view)
        
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
            self.moveContentDrawer(velocity.x > 0)
        default:
            break
        }
    }
    
    internal func moveContentDrawer(open:Bool) {
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            options: [],
            animations: { () -> Void in
                if let originalContentCenter = self.originalContentCenter {
                    if open {
                        self.contentView.center = CGPoint(
                            x: self.maxX,
                            y: originalContentCenter.y)
                    } else {
                        self.contentView.center = CGPoint(
                            x: self.minX,
                            y: originalContentCenter.y)
                    }
                    self.view.layoutIfNeeded()
                }
            },
            completion: nil)
    }

}
