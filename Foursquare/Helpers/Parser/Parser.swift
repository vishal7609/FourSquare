//
//  Parser.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import Foundation


class Parser {
    
    class func parseResturant(dictArray:NSArray) -> [Resturant] {
        
        var resturantArray:[Resturant] = [Resturant]()
        
        if (dictArray.count) > 0 {
            for dict in dictArray {
                let obj = Resturant(dict: dict as! NSDictionary)
                resturantArray.append(obj)
            }
        }
        return resturantArray
    }
    
    class func parserResturantDetail(response:NSDictionary) -> ResturantDetail {
        let venu = response["venue"] as? NSDictionary ?? NSDictionary()
        return ResturantDetail(response: venu)
    }
}
