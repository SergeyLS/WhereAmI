//
//  Location+CoreDataProperties.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/7/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: NSDate
    @NSManaged public var route: Route

}
