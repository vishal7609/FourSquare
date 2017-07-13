//
//  Resturant.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import Foundation


class Resturant {
    
    var allowMenuUrlEdit:String?
    var categoyrIcon:String?
    var id:String?
    var categoryId:String?
    var categoryName:String?
    var categoryShortName:String?
    var facebookId:String?
    var facebookName:String?
    var facebookUserName:String?
    var formatedPhone:String?
    var phone:String?
    var summary:String?
    var address:String?
    var city:String?
    var country:String?
    var crossStreet:String?
    var distance:Int?
    var lat:Double?
    var long:Double?
    var postalCode:String?
    var state:String?
    var url:String?
    var restName:String?
    
    
    
    init(dict:NSDictionary) {
        print(dict)
        if let menuEdit = dict["allowMenuUrlEdit"] as? String {
            self.allowMenuUrlEdit = menuEdit
        }
        
        
        if let categoryArray = dict["categories"] as? NSArray {
            if categoryArray.count > 0 {
                let category:NSDictionary = categoryArray.firstObject as! NSDictionary
                if let icon = category["icon"] as? NSDictionary {
                    if let prefix = icon["prefix"] as? String {
                        if let suffix = icon["suffix"] as? String {
                            self.categoyrIcon = prefix+suffix
                        }
                    }
                }
                if let id = category["id"] as? String {
                    self.categoryId = id
                }
                if let name = category["name"] as? String{
                    self.categoryName = name
                }
                if let sName = category["shortName"] as? String{
                    self.categoryShortName = sName
                }
            }
            
        }
        
        if let contact = dict["contact"] as? NSDictionary {
            self.facebookId = contact["facebook"] as? String ?? ""
            self.facebookName = contact["facebookName"] as? String ?? ""
            self.facebookUserName = contact["facebookUsername"] as? String ?? ""
            self.formatedPhone = contact["formattedPhone"] as? String ?? ""
            self.phone = contact["phone"] as? String ?? ""
        }
        
        if let hereNow = dict["hereNow"] as? NSDictionary {
            self.summary = hereNow["summary"] as? String ?? ""
            
        }
        
        if let id = dict["id"] as? String {
            self.id = id
        }
        
        if let location = dict["location"] as? NSDictionary {
            self.address = location["address"] as? String ?? ""
            self.city = location["city"] as? String ?? ""
            self.country = location["country"] as? String ?? ""
            self.crossStreet = location["crossStreet"] as? String ?? ""
            self.distance = location["distance"] as? Int ?? 0
            self.lat = location["lat"] as? Double ?? 0
            self.long = location["lng"] as? Double ?? 0
            self.postalCode = location["postalCode"] as? String ?? ""
            self.state = location["state"] as? String ?? ""
        }
        
        self.restName = dict["name"] as? String ?? ""
        self.url = dict["url"] as? String ?? ""
        
    }
}
