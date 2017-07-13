//
//  Review.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import Foundation


class Reviews {
    var name:String?
    var review:String?
    
    init(dic:NSDictionary) {
        if let user = dic["user"] as? NSDictionary {
            let firtName = user["firstName"] as? String ?? ""
            let lastName = user["lastName"] as? String ?? ""
            name = firtName + " " + lastName
        }
        self.review = dic["text"] as? String ?? ""
    }
    
    init(nmae:String, review:String){
        self.name = nmae
        self.review = review
    }
    
}
