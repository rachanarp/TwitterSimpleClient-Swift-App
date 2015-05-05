//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Rachana Bedekar on 5/2/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSignIn(sender: AnyObject) {
        
        TwitterClient().sharedInstance.loginWithCompletion ({ (user: User!, error:NSError!) -> Void in
            if let userObj = user {
                //modally present tweets view
                println("Welcome to : " + user.name!)
            } else {
                //Present error view
            }
        })
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
