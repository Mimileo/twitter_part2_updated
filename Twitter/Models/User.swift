//
//  User.swift
//  Twitter
//
//  Created by Mireya Leon on 10/1/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

class User : Equatable {
    //var header_image: URL?
    var user_id: String
    var screen_name: String
    
    
    // Initializer for Restaurant
    init(dict: [String:Any]) {
       // imageURL = URL(string: dict["image_url"] as! String)
        user_id = dict["user_id"] as! String
        screen_name = dict["screen_name"] as! String
    }
    
  
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.imageURL == rhs.imageURL &&
            lhs.name == rhs.name &&
            lhs.rating == rhs.rating &&
            lhs.reviews == rhs.reviews &&
            lhs.phone == rhs.phone &&
            lhs.url == rhs.url &&
            lhs.mainCategory == rhs.mainCategory
    }
    
}
