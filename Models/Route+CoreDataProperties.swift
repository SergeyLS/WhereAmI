//
//  Route+CoreDataProperties.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/7/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route");
    }

    @NSManaged public var distance: Double
    @NSManaged public var duration: Int64
    @NSManaged public var timestamp: Date
    @NSManaged public var locations: NSOrderedSet?

}

