//
//  Tweet.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation
import TimeAgoInWords

public class Tweet: NSObject {
    
    public static let CHARACTER_LIMIT: Int = 140
    public static var dateFormatter = NSDateFormatter()
    public static let ONE_HOUR = 60.0 * 60.0
    
    var idStr: String?
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userProfileImage: NSURL?
    var userName: String?
    var screenName: String?
    var inReplyToScreenName: String?
    var retweeted: Bool?
    var favorited: Bool?
    var user: User?
    
    init (dictionary: NSDictionary) {
        self.idStr = dictionary["id_str"] as? String
        self.text = dictionary["text"] as? String
        self.retweetCount = dictionary["retweet_count"] as? Int ?? 0
        self.favoritesCount = dictionary["favorite_count"] as? Int ?? 0
        
        if let createdAt = dictionary["created_at"] as? String {
            Tweet.dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            self.createdAt = Tweet.dateFormatter.dateFromString(createdAt)
        }
        
        if let urlString = dictionary.valueForKeyPath("user.profile_image_url_https") as? String {
            self.userProfileImage = NSURL(string: urlString)
        }
        
        self.userName = dictionary.valueForKeyPath("user.name") as? String
        self.screenName = dictionary.valueForKeyPath("user.screen_name") as? String
        self.inReplyToScreenName = dictionary["in_reply_to_screen_name"] as? String
        self.retweeted = dictionary["retweeted"] as? Bool
        self.favorited = dictionary["favorited"] as? Bool
        
        if let userDict = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: userDict)
        }
        
    }
    
    func getReadableCreatedAt(withHour:Bool = true) -> String? {
        if let createdAt = self.createdAt {
            Tweet.dateFormatter.dateFormat = "MM/d/YY" + (withHour ? ", h:mm a" : "")
            return Tweet.dateFormatter.stringFromDate(createdAt)
        }
        return nil
    }
    
    func getAutoRelativeCreatedAt() -> String? {
        if let createdAt = self.createdAt {
            let interval = -createdAt.timeIntervalSinceNow
            if interval > Tweet.ONE_HOUR {
                return self.getReadableCreatedAt(false)
            } else {
                let relative = NSDate(timeIntervalSinceNow: interval).timeAgoInWords()
                return relative
            }
        }
        return nil
    }
    
}