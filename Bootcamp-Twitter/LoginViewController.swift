//
//  LoginViewController.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/22/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonTouchUp(sender: UIButton) {
        TwitterClient.getInstance().getOauth(
            {
                TwitterClient.getInstance().fetchUser(
                    { (user: User?) -> Void in
                        TwitterApp.currentUser = user
                        self.performSegueWithIdentifier("com.lyft.segueToHome", sender: nil)
                    },
                    failure: { (error: NSError) -> Void in
                        print(error)
                })
            },
            failure: { (error: NSError!) -> Void in
                print(error)
            }
        )
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
