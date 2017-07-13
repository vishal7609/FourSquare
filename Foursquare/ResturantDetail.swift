//
//  ResturantDetail.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import Foundation

class ResturantDetail {
    
    var name:String?
    var address:String?
    var city:String?
    var country:String?
    var lat:Double?
    var long:Double?
    var state:String?
    
    var isOpen:Bool?
    var status:String?
    
    var description:String?
    
    var reviews:[Reviews] = [Reviews]()
    
    
    
    
    init(response:NSDictionary) {
        if let name = response["name"] as? String {
            self.name = name
        }
        
        if let location = response["location"] as? NSDictionary {
            self.address = location["address"] as? String ?? ""
            self.city = location["city"] as? String ?? ""
            self.country = location["country"] as? String ?? ""
            self.lat = location["lat"] as? Double ?? 0
            self.long = location["lng"] as? Double ?? 0
            self.state = location["state"] as? String ?? ""
        }
        
        if let hours = response["hours"] as? NSDictionary {
            self.isOpen = hours["isOpen"] as? Bool ?? false
            self.status = hours["status"] as? String ?? ""
            
        }
        
        self.description = response["description"] as? String ?? "This is very beautiful place"
        
        
        if let tips = response["tips"] as? NSDictionary {
            if let groups = tips["groups"] as? [NSDictionary] {
                for group in groups {
                    if let items = group["items"] as? [NSDictionary] {
                        for item in items {
                            let obj = Reviews(dic: item)
                            self.reviews.append(obj)
                        }
                    }
                }
            }
        }
        
    
        
    }
    
    
    
}
