//
//  User.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLogoutNotification = "UserDidLogoutNotification"


class User: NSObject{
    
    var name : String?
    var screenname : String?
    var profileImageUrl : String?
    var tagline : String?
    var dictionary : NSDictionary? = nil
    static let kCurrentUserKey : String = "kCurrentUserKey"
    
    static var currentUser : User? = nil
    
    
    func initWithDictionary(dictionary: NSDictionary) -> User?{
        if (dictionary.count > 0)
        {
            self.name = dictionary["name"] as? String
            self.screenname = dictionary["screen_name"] as? String
            self.profileImageUrl = dictionary["profile_image_url"] as? String
            self.tagline = dictionary["description"] as? String
            self.dictionary = dictionary
            return self
        }
        return nil
    }
    
    static func getCurrentUser() -> User? {
        if (currentUser == nil) {
            var defaults = NSUserDefaults.standardUserDefaults()
            let data: NSData? = (defaults.objectForKey(kCurrentUserKey) as? NSData)
            if (nil != data) {
                let dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                currentUser = User().initWithDictionary(dictionary)
            }
        }
        return currentUser
    }
    
     static func setCurrentUserWith(user : User?) {
        if (nil != currentUser) {
            NSUserDefaults.standardUserDefaults().setObject(NSJSONSerialization.dataWithJSONObject( NSDictionary() as AnyObject, options: NSJSONWritingOptions.allZeros, error: nil), forKey: kCurrentUserKey)
        } else {
           NSUserDefaults.standardUserDefaults().setObject(NSJSONSerialization.dataWithJSONObject(user!.dictionary as! AnyObject, options: NSJSONWritingOptions.allZeros, error: nil), forKey: kCurrentUserKey)
        }
        if (nil == user) {
             NSUserDefaults.standardUserDefaults().removeObjectForKey(kCurrentUserKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
