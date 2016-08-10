/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var resgiteredText: UILabel!
    
    @IBOutlet weak var signupBTNOTLT: UIButton!
    
    @IBOutlet weak var loginBTNOTLT: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func signup(sender: AnyObject) {
        
        var errorMessage = "Please try again later"
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Form empty!", message: "Please enter correct details")
            
        }
        
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive == true {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
            
                
            
                user.signUpInBackgroundWithBlock({ (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    if let errorString = error?.userInfo["error"] {
                        errorMessage = errorString as! String
                        self.displayAlert("Failed Signup", message: errorMessage)
                        }
                    }
                    else {
                        print("Signed up")
                    }
                
                })
            }
            else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Logged in")
                        
                    }
                    else {
                        if let errorString = error?.userInfo["error"] {
                            errorMessage = errorString as! String
                            self.displayAlert("Failed Login", message: errorMessage)
                        }
                    }
                    
                })
                
                
                
            }
        }
    }
    
    
    var signupActive = true
    
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive {
            
            signupBTNOTLT.setTitle("Log In", forState: UIControlState.Normal)
            resgiteredText.text = "Not registered?"
            loginBTNOTLT.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        }
        
        else {
            
            signupBTNOTLT.setTitle("Sign Up", forState: UIControlState.Normal)
            resgiteredText.text = "Already registered?"
            loginBTNOTLT.setTitle("Log In", forState: UIControlState.Normal)
            
            
        }
        
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    func displayAlert(title: String, message: String) {
        
        if #available(iOS 8.0, *) {
            
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
