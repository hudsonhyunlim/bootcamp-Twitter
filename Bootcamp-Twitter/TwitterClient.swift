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
    let REQUEST_TOKEN_URL = "oauth/request_token"
    let AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
    let ACCESS_TOKEN_URL = "oauth/access_token"
    static let CONSUMER_KEY = "x3otLOMpVyOAuwi9qFNL5lR9v"
    static let CONSUMER_SECRET = "BtMHEqvc6onvxC5EtdN1NLuMk4buJTkW08XTdQd4INTMvxcJc2"
    var accessToken:BDBOAuth1Credential?
    var session:BDBOAuth1SessionManager?
    
    init() {
        self.session = TwitterClient.sessionManager()
    }
    
    func getOauth() {
        guard let session = self.session else {
            return
        }
        
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
                print("access token set")
            },
            failure: { (error: NSError!) -> Void in
                print(error.localizedDescription)
            })
    }
    
    func fetchUser(complete: () -> Void) {
        guard let session = self.session else {
            complete()
            return
        }
        session.GET(
            TwitterClient.VERIFY_CREDENTIALS,
            parameters: nil,
            progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print(response)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        })

    }
    
    public static func sessionManager() -> BDBOAuth1SessionManager {
        return BDBOAuth1SessionManager(
            baseURL: NSURL(string: TwitterClient.TWITTER_BASE),
            consumerKey: TwitterClient.CONSUMER_KEY,
            consumerSecret: TwitterClient.CONSUMER_SECRET)
    }
    
}