//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

let kTwitterConsumerKey : String = ""
let kTwitterConsumerSecret : String = ""
let kTwitterBaseUrl : String = "https://api.twitter.com"



class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion : ((user:User!, error:NSError!)->Void)? = nil
    
    var sharedInstance :TwitterClient {
        struct Singleton {
            static let instance = TwitterClient(baseURL: NSURL(string:kTwitterBaseUrl), consumerKey: kTwitterConsumerKey, consumerSecret: kTwitterConsumerSecret)
        }
        
        return Singleton.instance
    }
    
    func loginWithCompletion(completion:(user:User!, error:NSError!)->Void) {
        self.loginCompletion = completion
        self.requestSerializer.removeAccessToken()
        
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterclient://oauth"), scope: nil, success: {( requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token!")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken.token)
            UIApplication.sharedApplication().openURL(authURL!)
           
            
            }, failure:{ (err : NSError!) -> Void in
                println(err)
                self.loginCompletion!(user: nil, error: err)
        })

    }
    
    func logout() {
        User.setCurrentUserWith(nil)
        self.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLogoutNotification, object: nil))
    }
    
    func openURL(url: NSURL) {
        
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("got access token")
            
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters:nil, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
                let response = responseObject as! NSDictionary
                var user = User()
                user.initWithDictionary(response)
                User.setCurrentUserWith(user)
                self.loginCompletion!(user:user, error:nil)
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLoginNotification, object: nil))
                
                
                }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println(error)
                    self.loginCompletion!(user:nil, error:error)
            })
            
            }, failure: { (error: NSError!) -> Void in
                println(error)
                self.loginCompletion!(user:nil, error:error)
        })
    }
    
    func postTweet(newTweet:String?, replyTweetID:NSNumber?, completion:(bPosted:String!, error:NSError!)->Void)
    {
        var params = NSMutableDictionary()
        
        if (nil != newTweet)
        {
            params["status"] = newTweet
            if (nil != replyTweetID) {
                params["in_reply_to_status_id"] = replyTweetID!
            }
            
            self.POST("https://api.twitter.com/1.1/statuses/update.json", parameters: params, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
            
            let response : NSDictionary = responseObject as! NSDictionary
            println(responseObject)
            
            completion(bPosted: "Success", error: nil)
            
            }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println(error)
                completion(bPosted: "Failure", error: error)
        })
        }
    }
    
    func retweet(tweetId:NSNumber?, completion:(bPosted:String!, error:NSError!)->Void)
    {
        var params = NSMutableDictionary()
        
        if (nil != tweetId)
        {
            params["id"] = tweetId
            let idstr: String? = tweetId?.stringValue
            let posturl : String = "https://api.twitter.com/1.1/statuses/retweet/" + idstr! + ".json"
            self.POST(posturl, parameters: params, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
                
                let response : NSDictionary = responseObject as! NSDictionary
                println(responseObject)
                
                completion(bPosted: "Success", error: nil)
                
                }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println(error)
                    completion(bPosted: "Failure", error: error)
            })
        }
    }
    
    
    func favorite(tweetId:NSNumber?, completion:(bPosted:String!, error:NSError!)->Void)
    {
        var params = NSMutableDictionary()
        
        if (nil != tweetId)
        {
            params["id"] = tweetId
            
            self.POST("https://api.twitter.com/1.1/favorites/create.json", parameters: params, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
                
                let response : NSDictionary = responseObject as! NSDictionary
                println(responseObject)
                
                completion(bPosted: "Success", error: nil)
                
                }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println(error)
                    completion(bPosted: "Failure", error: error)
            })
        }
    }

    
    func homeTimeLineWithParams (dictionary : NSDictionary?, completion:(tweets:[Tweet]!, error:NSError!)->Void) {
        var tweets : [Tweet]?
        self.GET("1.1/statuses/home_timeline.json", parameters:nil, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
            println("Received Tweets! ")
        
            tweets = Tweet().tweetsWithArray(responseObject as! NSArray)
            completion(tweets: tweets, error:nil)
        
        }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error)
            completion(tweets: nil, error: error)
        })
    }
   
}
