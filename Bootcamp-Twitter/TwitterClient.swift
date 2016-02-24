//
//  TwitterClient.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

public class TwitterClient {
    
    static let TWITTER_BASE = "https://api.twitter.com"
    static let VERIFY_CREDENTIALS = "1.1/account/verify_credentials.json"
    static let HOME_TIME_LINE = "1.1/statuses/home_timeline.json"
    static let STATUSES_UPDATE = "1.1/statuses/update.json"
    static let FAVORITE_CREATE = "1.1/favorites/create.json"
    static let FAVORITE_DESTROY = "1.1/favorites/destroy.json"
    let REQUEST_TOKEN_URL = "oauth/request_token"
    let AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
    let ACCESS_TOKEN_URL = "oauth/access_token"
    static let CONSUMER_KEY = "x3otLOMpVyOAuwi9qFNL5lR9v"
    static let CONSUMER_SECRET = "BtMHEqvc6onvxC5EtdN1NLuMk4buJTkW08XTdQd4INTMvxcJc2"
    var accessToken:BDBOAuth1Credential?
    var session:BDBOAuth1SessionManager?
    
    private var loginSuccess: (() -> Void)?
    private var loginFailure: ((NSError!) -> Void)?
    
    public var postInFlight: Bool = false
    
    private static var instance:TwitterClient?
    
    private init() {
        self.session = TwitterClient.sessionManager()
    }
    
    public static func getInstance() -> TwitterClient {
        if TwitterClient.instance == nil {
            TwitterClient.instance = TwitterClient()
        }
        return TwitterClient.instance!
    }
    
    func getOauth(success: () -> Void, failure: (NSError!) -> Void) {
        guard let session = self.session else {
            return
        }
        
        self.loginSuccess = success
        self.loginFailure = failure
        
        session.deauthorize()
        session.fetchRequestTokenWithPath(
            self.REQUEST_TOKEN_URL,
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                let authUrl = NSURL(string: self.AUTHORIZE_URL + "?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(authUrl)
            },
            failure: {(error: NSError!) -> Void in
                print(error.localizedDescription)
                failure(error)
        })
    }
    
    func getAccess(requestToken: BDBOAuth1Credential) {
        guard let session = self.session else {
            return
        }
        session.fetchAccessTokenWithPath(
            self.ACCESS_TOKEN_URL,
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.accessToken = accessToken
                self.loginSuccess?()
            },
            failure: { (error: NSError!) -> Void in
                print(error.localizedDescription)
                self.loginFailure?(error)
            })
    }
    
    func fetchUser(success: (User?) -> Void, failure: (NSError) -> Void) {
        guard let session = self.session else {
            success(nil)
            return
        }
        session.GET(
            TwitterClient.VERIFY_CREDENTIALS,
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let userDictionary = response as? NSDictionary {
                    success(User(dictionary: userDictionary))
                } else {
                    success(nil)
                }
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure(error)
        })

    }
    
    func fetchTweets(success: ([Tweet]?) -> Void, failure: (NSError) -> Void) {
        guard let session = self.session else {
            success(nil)
            return
        }
        
        session.GET(
            TwitterClient.HOME_TIME_LINE,
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let tweetsArray = response as? [NSDictionary] {
                    var tweets = [Tweet]()
                    
                    for tweetDict in tweetsArray {
                        tweets.append(Tweet(dictionary: tweetDict))
                    }
                    
                    success(tweets)
                } else {
                    success(nil)
                }
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func updateStatus(status: String, inReplyToStatusId: String?, success: (Tweet) -> Void, failure: (NSError?) -> Void) {
        var params = [
            "status": status
        ]
        if let inReplyToStatusId = inReplyToStatusId {
            params["in_reply_to_status_id"] = inReplyToStatusId
        }
        
        self.post(
            TwitterClient.STATUSES_UPDATE,
            params: params,
            success: success,
            failure: failure)
    }
    
    func favoriteCreate(id: String, success: (Tweet) -> Void, failure: (NSError?) -> Void) {
        let params = [
            "id": id
        ]
        self.post(
            TwitterClient.FAVORITE_CREATE,
            params: params,
            success: success,
            failure: failure)
    }
    
    func favoriteDestroy(id: String, success: (Tweet) -> Void, failure: (NSError?) -> Void) {
        let params = [
            "id": id
        ]
        self.post(
            TwitterClient.FAVORITE_DESTROY,
            params: params,
            success: success,
            failure: failure)
    }
    
    private func post(url: String, params: [String:String], success: (Tweet) -> Void, failure: (NSError?) -> Void) {
        guard let session = self.session else {
            failure(nil)
            return
        }
        
        if self.postInFlight {
            failure(nil)
            return
        }
        
        self.postInFlight = true
        
        session.POST(
            url,
            parameters: params,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let tweetDict = response as? NSDictionary {
                    let tweet = Tweet(dictionary: tweetDict)
                    self.postInFlight = false
                    success(tweet)
                }
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                self.postInFlight = false
                failure(error)
        })
    }
    
    func logout() {
        self.session?.deauthorize()
    }
    
    public static func sessionManager() -> BDBOAuth1SessionManager {
        return BDBOAuth1SessionManager(
            baseURL: NSURL(string: TwitterClient.TWITTER_BASE),
            consumerKey: TwitterClient.CONSUMER_KEY,
            consumerSecret: TwitterClient.CONSUMER_SECRET)
    }
    
}