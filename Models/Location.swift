//
//  Location+CoreDataClass.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/7/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Location: NSManagedObject {

    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Location"
    
    
    //==================================================
    // MARK: - Init
    //==================================================
    
    convenience init?(latitude: Double, longitude: Double, timestamp: Date){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Location.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(Location.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        
        
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        
        print("add new \(Location.type): \(self.timestamp)")
    }

    
}
