//
//  ViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets:[Tweet]?
    var tweetListType:TwitterApp.TweetListType?
    var reloadCache: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tweetsTableView.delegate = self
        self.tweetsTableView.dataSource = self
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: "refreshControlAction:",
            forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        self.loadTweets(false, complete: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogoutTap(sender: UIBarButtonItem) {
        TwitterApp.logout()
    }
    
    private func loadTweets(cached: Bool, complete: (() -> Void)?) {
        if let tweetListType = self.tweetListType {
            if cached {
                self.tweets = TwitterApp.getInstance().getCachedTweets(tweetListType)
                self.tweetsTableView.reloadData()
            } else {
                TwitterApp.getInstance().fetchTweets(
                    tweetListType,
                    complete : { (tweets: [Tweet]?) -> Void in
                        self.tweets = tweets
                        self.tweetsTableView.reloadData()
                        complete?()
                    })
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.loadTweets(
            false,
            complete: {
                refreshControl.endRefreshing()
            })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "com.lyft.segueToTweetDetail" {
            if let cell = sender as? TweetCell,
               let tweets = self.tweets,
               let navVc = segue.destinationViewController as? UINavigationController,
               let vc = navVc.topViewController as? TweetDetailViewController,
               let indexPath = self.tweetsTableView.indexPathForCell(cell) {
                let tweet = tweets[indexPath.row]
                vc.tweet = tweet
                vc.delegate = self
            }
        } else if segue.identifier == "com.lyft.segueToEdit" {
            if let navVc = segue.destinationViewController as? UINavigationController,
               let vc = navVc.topViewController as? TweetEditViewController {
                vc.delegate = self
            }
        } else if segue.identifier == "com.lyft.segueTweetsToUser" {
            if let user = sender as? User,
               let navVc = segue.destinationViewController as? UINavigationController,
               let vc = navVc.topViewController as? UserProfileViewController {
                vc.user = user
                vc.dismissable = true
            }
        }
    }

}

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let tweets = self.tweets {
            cell.tweet = tweets[indexPath.row]
            cell.delegate = self
        }
        
        // hack to remove insets in separators
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
}

extension TweetsViewController: UITableViewDelegate {}

extension TweetsViewController: TweetEditViewControllerDelegate {
    
    func tweetEditViewController(tweetEditViewController: TweetEditViewController, didPostTweet tweet: Tweet) {
        if let tweetListType = self.tweetListType {
            TwitterApp.getInstance().addNewestTweet(tweetListType, tweet: tweet)
            self.loadTweets(
                true,
                complete: nil
            )
        }
    }
    
}

extension TweetsViewController: TweetDetailViewControllerDelegate {
    
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweetDidChange tweet: Tweet) {
        if let tweetListType = self.tweetListType {
            TwitterApp.getInstance().replaceTweet(tweetListType, with: tweet)
            self.loadTweets(true, complete: nil)
        }
    }
    
}

extension TweetsViewController: TweetCellDelegate {
    
    func tweetCell(tweetCell: TweetCell, receivedUserViewRequest user: User?) {
        if let user = user {
            self.performSegueWithIdentifier("com.lyft.segueTweetsToUser", sender: user)
        }
    }
    
}