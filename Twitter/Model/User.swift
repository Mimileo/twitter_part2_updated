//
//  User.swift
//  Twitter
//
//  Created by Mireya Leon on 10/2/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    // Establish Properties
    var imageURL: URL?
    var tagline: String
    var numOfTweets: Int
    var numOfFollowers: Int
    var numOfFollowings: Int
    var screenname: String

    //  initializer for User
    init(dict: [String: Any]) {
        let profileImageurl = (dict["profile_image_url_https"] as? String)!
        let start = profileImageurl.startIndex
        let end = profileImageurl.index(profileImageurl.endIndex, offsetBy: -10)
        let format = profileImageurl.suffix(3)
        let baseprofile = profileImageurl[start ..< end] + "bigger." + String(format)
        
               
        //let imageUrl = URL(string: String(baseprofile))
       // let data = try? Data(contentsOf: imageUrl!)
        imageURL = URL(string: String(baseprofile))
        tagline = dict["description"] as! String // Nullable . The user-defined UTF-8 string describing their account
        numOfTweets = dict["statuses_count"] as! Int // The number of Tweets (including retweets) issued by the user
        numOfFollowers = dict["followers_count"] as! Int  // The number of followers this account currently has.
        numOfFollowings = dict["friends_count"] as!  Int  // The number of users this account is following (AKA their “followings”)
        screenname = dict["screen_name"] as! String
                
    }
    
}
