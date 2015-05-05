//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var retweetedByLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeSinceCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetImgView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweetEntry : Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tweetImgView.layer.cornerRadius = 3
        self.tweetImgView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(tweet: Tweet) {
        self.retweetedByLabel.text = ""
        self.nameLabel.text = tweet.author?.name
        self.tweetTextLabel.text = tweet.text
        let screentext = (tweet.author!.screenname)!
        self.handleLabel.text = String("@" + screentext)
        let profileURL = tweet.author?.profileImageUrl
        self.tweetImgView.setImageWithURL(NSURL(string:profileURL!))
        self.tweetEntry = tweet
    }
    
    @IBAction func onReply(sender: AnyObject) {
        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var newReplyViewController = storyboard.instantiateViewControllerWithIdentifier("newReplyVC")  as! NewTweetViewController
        newReplyViewController.tweetID = self.tweetEntry?.id

        self.window?.rootViewController?.presentViewController(UINavigationController(rootViewController: newReplyViewController), animated: true, completion: nil)
    }
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient().sharedInstance.retweet(self.tweetEntry?.id, completion: { (bPosted:String!, error:NSError!) -> Void in
            println("TODO: handle retweet " + bPosted)
        })
    }
    @IBAction func onStar(sender: AnyObject) {
        TwitterClient().sharedInstance.favorite(self.tweetEntry?.id, completion: { (bPosted:String!, error:NSError!) -> Void in
            println("TODO: handle favorite " + bPosted)
        })
    }
}
