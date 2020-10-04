//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Mireya Leon on 10/1/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage


class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var tagLineLabel: UILabel!
    
    @IBOutlet weak var tweetsCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screennameLabel: UILabel!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        print(user_id!)
        //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loadUserData), userInfo: nil, repeats: true)
        //loadUserData(user_id!)
        
        loadHeaderImage(user_id ?? "Nothing")
        //loadFollowersCount(user_id ?? "Nothing")
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        let user_id = UserDefaults.standard.string(forKey: "user_id")
           self.loadUserData(user_id!)
       }
    
    func loadHeaderImage(_ userid:String) {
        
        let myUrl = "https://api.twitter.com/1.1/users/profile_banner.json"

       
        let myParams = ["user_id": userid]

        TwitterAPICaller.client?.getUserImageDictionary(url: myUrl, parameters: myParams, success: { (imgData: [String : Any]) in
            
            let imgdata = imgData["sizes"] as? [String: Any]
            let mobile_size = imgdata!["mobile_retina"] as? [String: Any]
            let url = mobile_size?["url"]
            
            let imageUrl = URL(string: url as! String)
            let data = try? Data(contentsOf: imageUrl!)
                       
            if let imageData = data {
                self.headerImageView.image = UIImage(data: imageData)
            }
            // update table with new data
           
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("Could not retrieve data!")
        })
       
       
    }
    
    @objc func loadUserData(_ userid:String) {
        let myUrl = "https://api.twitter.com/1.1/users/show.json"

        let myParams = ["user_id": userid]
        
        TwitterAPICaller.client?.getCurrentUserData(url: myUrl, parameters: myParams, success: {(userObject: [String: Any]) in
            if let userData = userObject as? [String: Any] {
                
                self.currentUser = User(dict: userObject)
                print(self.currentUser.imageURL)
                print(self.currentUser.tagline)
                print(self.currentUser.numOfTweets)
                print(self.currentUser.numOfFollowers)
                self.tagLineLabel.text = "\(self.currentUser.tagline)"
                self.tweetsCount.text = "\(self.currentUser.numOfTweets)"
                self.followingCount.text = "\(self.currentUser.numOfFollowings)"
                self.followersCount.text = "\(self.currentUser.numOfFollowers)"
                self.screennameLabel.text = "@\(self.currentUser.screenname)"
               
              
                let imageUrl = self.currentUser.imageURL
                           let data = try? Data(contentsOf: imageUrl!)
                                      
                           if let imageData = data {
                            self.profileImageView.image = UIImage(data: imageData)
                            self.profileImageView.layer.borderWidth = 1.0
                            self.profileImageView.layer.masksToBounds = false
                            //cell.profileImageView.bounds.size = CGSize(width: 100, height: 100)
                            self.profileImageView.layer.borderColor = UIColor.white.cgColor
                            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                                //cell.profileImageView.frame.size.width / 2

                            self.profileImageView.clipsToBounds = true
                           }

                
            }
            
            //print(followers!["total_count"])
            
        }, failure: { (Error) in
             print(Error.localizedDescription)
            print("Could not retrieve followers!")
        })
    }
    
    
    func loadFollowersCount(_ userid:String) {
        let myUrl = "https://api.twitter.com/1.1/followers/ids.json"

        let myParams = ["user_id": userid]
        
        TwitterAPICaller.client?.getFollowers(url: myUrl, parameters: myParams, success: {(followerData: [String : Any]) in
            if let followers = followerData as? [String:Any] {
                if let followerIds = followers["ids"] as? Float {
                       print("\(followerIds)")
                   }
            }
            
            //print(followers!["total_count"])
            
        }, failure: { (Error) in
             print(Error.localizedDescription)
            print("Could not retrieve followers!")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
