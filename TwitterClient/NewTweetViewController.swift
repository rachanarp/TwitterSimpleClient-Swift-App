//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetView: UITextField!
    
    var tweetID : NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = User.currentUser?.name
        let screentext = (User.currentUser?.screenname)!
        handleLabel.text = String("@" + screentext)
        let profileURL = User.currentUser?.profileImageUrl
        profileImgView.setImageWithURL(NSURL(string:profileURL!))
        tweetView.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let newtweet : String? = tweetView.text;
        
        TwitterClient().sharedInstance.postTweet(newtweet, replyTweetID:nil, completion: {(bPosted:String!, error:NSError!) -> Void in
            println("new Tweet was posted = " + bPosted)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
