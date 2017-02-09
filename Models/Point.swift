//
//  Point+CoreDataClass.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/9/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Point: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Point"
    
    
    //==================================================
    // MARK: - Init
    //==================================================
    
    convenience init?(latitude: Double, longitude: Double, title: String, subtitle: String){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Point.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(Point.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        
        
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
        
        
        print("add new \(Point.type): \(self.title)")
    }

}
