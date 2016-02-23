//
//  Tweet.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import Foundation

public class Tweet: NSObject {
    
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init (dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        self.retweetCount = dictionary["retweet_count"] as? Int ?? 0
        self.favoritesCount = dictionary["favorites_count"] as? Int ?? 0
        
        if let createdAt = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            self.createdAt = formatter.dateFromString(createdAt)
        }
    }
    
}