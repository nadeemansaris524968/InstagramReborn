//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nadeem Ansari on 8/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image:UIImagePickerController = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        
    }
    
    @IBOutlet weak var message: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        if imageToPost.image != nil && message.text != "" {
        
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = self.imageToPost.center
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
            var post = PFObject(className: "Post")
            post["message"] = message.text
            post["userId"] = PFUser.currentUser()?.objectId
        
            let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
            let imageFile = PFFile(name: "image.png", data: imageData!)
        
            post["imageFile"] = imageFile
        
            post.saveInBackgroundWithBlock { (success, error) in
            
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
                if success {
                    
                    
                    if #available(iOS 8.0, *) {
                        
                        let alert: UIAlertController = UIAlertController(title: "Success!", message: "Image posted successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    self.imageToPost.image = UIImage(named: "image-placeholder.png")
                    self.message.text = ""

                }
            
            }
        }
        else {
            if #available(iOS 8.0, *) {
                
                let alert: UIAlertController = UIAlertController(title: "Image or message empty!", message: "Please choose an image and enter a message as well.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
