//
//  Review+CoreDataProperties.swift
//  
//
//  Created by Vishal on 22/03/17.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review");
    }

    @NSManaged public var name: String?
    @NSManaged public var review: String?
    @NSManaged public var id: String?

}
