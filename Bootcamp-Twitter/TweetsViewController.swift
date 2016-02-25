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
        
        self.loadHomeTweets(false, complete: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogoutTap(sender: UIBarButtonItem) {
        TwitterApp.logout()
    }
    
    private func loadHomeTweets(cached: Bool, complete: (() -> Void)?) {
        if cached {
            self.tweets = TwitterApp.getInstance().getCachedTweets(TwitterApp.TweetListType.Home)
            self.tweetsTableView.reloadData()
        } else {
            TwitterApp.getInstance().fetchTweets(
                TwitterApp.TweetListType.Home,
                complete : { (tweets: [Tweet]?) -> Void in
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                    complete?()
                })
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.loadHomeTweets(
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
        }
    }

}

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.lyft.TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if let tweets = self.tweets {
            cell.tweet = tweets[indexPath.row]
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
        TwitterApp.getInstance().addNewestTweet(TwitterApp.TweetListType.Home, tweet: tweet)
        self.loadHomeTweets(
            true,
            complete: nil
        )
    }
    
}

extension TweetsViewController: TweetDetailViewControllerDelegate {
    
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweetDidChange tweet: Tweet) {
        TwitterApp.getInstance().replaceTweet(TwitterApp.TweetListType.Home, with: tweet)
        self.loadHomeTweets(true, complete: nil)
    }
    
}