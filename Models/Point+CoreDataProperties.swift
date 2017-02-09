//
//  Point+CoreDataProperties.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/9/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Point {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String
    @NSManaged public var subtitle: String

}
