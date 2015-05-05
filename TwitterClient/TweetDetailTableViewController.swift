//
//  TweetDetailTableViewController.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {

    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetImgView: UIImageView!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var currentTweet : Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.retweetedByLabel.text = ""
        self.nameLabel.text = currentTweet?.author?.name
        let screentext = (currentTweet?.author!.screenname)!
        self.handleLabel.text = String("@" + screentext)
        self.tweetLabel.text = currentTweet?.text
        let profileURL = currentTweet?.author?.profileImageUrl
        self.tweetImgView.setImageWithURL(NSURL(string:profileURL!))
        self.createdOnLabel.text = currentTweet?.createdAt
        println(currentTweet?.createdAt)
        self.retweetsLabel.text = currentTweet?.retweetCount?.stringValue
        self.favoritesLabel.text = currentTweet?.favoritesCount!.stringValue
    }

    @IBAction func onReply(sender: AnyObject) {
        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var newReplyViewController = storyboard.instantiateViewControllerWithIdentifier("newReplyVC")  as! NewTweetViewController
        newReplyViewController.tweetID = self.currentTweet?.id
        
        self.presentViewController(UINavigationController(rootViewController: newReplyViewController), animated: true, completion: nil)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient().sharedInstance.retweet(self.currentTweet?.id, completion: { (bPosted:String!, error:NSError!) -> Void in
            println("TODO: handle retweet " + bPosted)
        })
    }
    
    @IBAction func onStar(sender: AnyObject) {
        TwitterClient().sharedInstance.favorite(self.currentTweet?.id, completion: { (bPosted:String!, error:NSError!) -> Void in
            println("TODO: handle favorite " + bPosted)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
