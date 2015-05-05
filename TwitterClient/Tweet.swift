//
//  Tweet.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text : String?
    var createdAt : String?
    var author : User?
    var retweetCount : NSNumber?
    var favoritesCount : NSNumber?
    var retweeted : NSNumber?
    var id : NSNumber?
    var dateCreated : NSDate?
    
    
    func initWithDictionary(dictionary: NSDictionary) -> Tweet{
        self.text = dictionary["text"] as? String
        self.createdAt = dictionary["created_at"] as? String
        self.author = User().initWithDictionary(dictionary["user"] as! NSDictionary)
        self.retweetCount = dictionary["retweet_count"] as? NSNumber
        self.favoritesCount = dictionary["favorite_count"] as? NSNumber
        self.retweeted = dictionary["retweeted"] as? NSNumber
        let idstr = dictionary["id_str"] as? String
        self.id = NSNumberFormatter().numberFromString(idstr!)
            
        return self
    }
    
    func tweetsWithArray(array: NSArray) -> [Tweet] {
        var Tweets = NSMutableArray()
        
        for element : AnyObject in array {
            if let tweetElement = element as? NSDictionary {
                let tweet : Tweet = Tweet().initWithDictionary(tweetElement)
                //println(tweet.text! + ":" + tweet.createdAt!)
                //println("----------------------------------")
                //println(tweetElement)
                Tweets.addObject(tweet)
            }
        }
        return (Tweets as NSArray) as! [Tweet]
    }
   
}
