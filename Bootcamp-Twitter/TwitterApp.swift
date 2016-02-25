//
//  TwitterApp.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/23/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation
import UIKit

public final class TwitterApp {
    
    private static let SERIALIZED_USER_KEY = "com.lyft.serialized_user_key"
    public static let LOGOUT_NOTIFICATION_KEY = "com.lyft.logout_notification"
    private static var _currentUser: User?
    private static let defaults = NSUserDefaults.standardUserDefaults()
    
    public static let favoriteOn = UIImage(named: "like-action-on")
    public static let favoriteOff = UIImage(named: "like-action")
    public static let retweetOn = UIImage(named: "retweet-action-on")
    public static let retweetOff = UIImage(named: "retweet-action")
    
    public enum TweetListType {
        case Home
    }
    private var cachedTweets: [TweetListType : [Tweet] ] = [:]
    
    private static var _instance: TwitterApp?
    
    private init() {
        self.cachedTweets[TweetListType.Home] = [Tweet]()
    }
    
    public static func getInstance() -> TwitterApp {
        if TwitterApp._instance == nil {
            TwitterApp._instance = TwitterApp()
        }
        return TwitterApp._instance!
    }
    
    public func fetchTweets(type: TweetListType, complete: (([Tweet]?) -> Void)? ) {
        TwitterClient.getInstance().fetchTweets(
            { (tweets: [Tweet]?) -> Void in
                self.cachedTweets[type] = tweets
                complete?(tweets)
            },
            failure: { (error: NSError) -> Void in
                print(error)
        })
    }
    
    public func getCachedTweets(type: TweetListType) -> [Tweet]? {
        return self.cachedTweets[type]
    }
    
    public func addNewestTweet(type: TweetListType, tweet: Tweet) -> [Tweet]? {
        self.cachedTweets[type]?.insert(tweet, atIndex: 0)
        return self.cachedTweets[type]
    }
    
    public func replaceTweet(type: TweetListType, with newTweet: Tweet) -> [Tweet]? {
        let list = self.cachedTweets[type]
        
        if let list = list {
            for (index, tweet) in list.enumerate() {
                if (tweet.idStr == newTweet.idStr) {
                    self.cachedTweets[type]![index] = newTweet
                    break
                }
            }
        }
        
        return list
    }
    
    public static var currentUser: User? {
        get {
            if TwitterApp._currentUser == nil {
                if let data = TwitterApp.defaults.objectForKey(TwitterApp.SERIALIZED_USER_KEY) as? NSData,
                   let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    TwitterApp._currentUser = User(dictionary: dictionary)
                }
        
            }
            return TwitterApp._currentUser
        }
        set(user) {
            if let dictionary = user?.dictionary {
                let obj = try! NSJSONSerialization.dataWithJSONObject(
                    dictionary,
                    options: [])
                TwitterApp.defaults.setObject(
                    obj,
                    forKey: TwitterApp.SERIALIZED_USER_KEY)
            } else {
                TwitterApp.defaults.setObject(
                    nil,
                    forKey: TwitterApp.SERIALIZED_USER_KEY)
            }
            TwitterApp.defaults.synchronize()
        }
    }
    
    public static func logout() {
        TwitterClient.getInstance().logout()
        TwitterApp.currentUser = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            TwitterApp.LOGOUT_NOTIFICATION_KEY,
            object: nil)
    }
    
}