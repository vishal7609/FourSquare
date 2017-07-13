//
//  DatabaseServiceManager.swift
//  Retail Store
//
//  Created by Vishal on 04/02/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import Foundation
import CoreData


class DatabaseServiceManager {
    

    
    
    class func fetchReview(_ id:String, success: @escaping (_ response: [Reviews]) -> Void, failure: @escaping (_ error: NSError?) -> Void ){
        
        let fetchRequest:NSFetchRequest<Review> = Review.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let searchResult =  try DatabaseController.getContext().fetch(fetchRequest)
            if searchResult.count > 0 {
                print("No of result \(searchResult.count)")
                
                var reviews:[Reviews] = [Reviews]()
                
                for review in searchResult {
                    let obj = Reviews(nmae: review.name!, review: review.review!)
                    reviews.append(obj)
                }
                
                success(reviews)
            }
        } catch  {
            print(error)
            failure(error as NSError?)
        }
    }
    
    
    
    
    class func createReview(_ name:String, id:String, review:String, success: @escaping (_ response: String) -> Void ){
        let userReview:Review = NSEntityDescription.insertNewObject(forEntityName: String(describing: Review.self), into: DatabaseController.getContext()) as! Review
        userReview.id = id
        userReview.name = name
        userReview.review = review
        DatabaseController.saveContext()
        success("Succesfully Added")
    }
    
    
}
