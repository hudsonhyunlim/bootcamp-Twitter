//
//  Tweet.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation

public class Tweet: NSObject {
    
    public static let CHARACTER_LIMIT: Int = 140
    
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
    
    init (dictionary: NSDictionary) {
        self.idStr = dictionary["id_str"] as? String
        self.text = dictionary["text"] as? String
        self.retweetCount = dictionary["retweet_count"] as? Int ?? 0
        self.favoritesCount = dictionary["favorites_count"] as? Int ?? 0
        
        if let createdAt = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            self.createdAt = formatter.dateFromString(createdAt)
        }
        
        if let urlString = dictionary.valueForKeyPath("user.profile_image_url_https") as? String {
            self.userProfileImage = NSURL(string: urlString)
        }
        
        self.userName = dictionary.valueForKeyPath("user.name") as? String
        self.screenName = dictionary.valueForKeyPath("user.screen_name") as? String
        self.inReplyToScreenName = dictionary["in_reply_to_screen_name"] as? String
        self.retweeted = dictionary["retweeted"] as? Bool
        
    }
    
}