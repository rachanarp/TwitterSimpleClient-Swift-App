//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets = NSArray()
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:("onRefresh"), name: UserDidLoginNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector:("onLogout"), name: UserDidLogoutNotification, object: nil)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = CGFloat(120)
    }
    
    override func viewWillAppear(animated: Bool) {
        let user : User? = User.getCurrentUser()
        if (nil == user)
        {
            println("TweetsVC should not be loaded when currentUser as nil")
            
        } else {
            onRefresh()
        }
    }

    func onLogout() {
        println ("Nothing to do")
    }
    
    
    func onRefresh() {
        TwitterClient().sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets:[Tweet]!, error:NSError!) -> Void in
            if (nil != tweets) {
                for tweet : Tweet in tweets {
                    println(tweet.text)
                }
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })

        self.refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNewButton(sender: AnyObject) {
        
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        TwitterClient().sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        let tweet : Tweet = self.tweets[indexPath.row] as! Tweet
        cell.setTweet(tweet)
        return cell;
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "tweetDetailSegue") {
            // pass data to next view
            if let viewController: TweetDetailTableViewController = segue.destinationViewController as? TweetDetailTableViewController {
                let tweetcell : TweetTableViewCell = sender as! TweetTableViewCell
                viewController.currentTweet = tweetcell.tweetEntry
            }
        }
        else
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
        }
    }


}
