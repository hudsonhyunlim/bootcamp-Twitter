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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tweetsTableView.delegate = self
        self.tweetsTableView.dataSource = self
        self.tweetsTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetsTableView.estimatedRowHeight = 120
        
        self.loadHomeTweets()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadHomeTweets() {
        TwitterClient.getInstance().fetchTweets(
            { (tweets: [Tweet]?) -> Void in
                print("foba")
                self.tweets = tweets
                self.tweetsTableView.reloadData()
            },
            failure: { (error: NSError) -> Void in
                print(error)
        })
    }

}

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("celly")
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
            print("county")
            return tweets.count
        } else {
            return 0
        }
    }
}

extension TweetsViewController: UITableViewDelegate {}