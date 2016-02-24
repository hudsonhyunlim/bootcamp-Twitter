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