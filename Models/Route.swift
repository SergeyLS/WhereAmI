//
//  Route+CoreDataClass.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/7/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Route: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Route"
    
    
    convenience init?(distance: Double, duration: Int64){
        guard let tempEntity = NSEntityDescription.entity(forEntityName: Route.type, in: CoreDataManager.shared.viewContext) else {
            fatalError("Could not initialize \(Route.type)")
            return nil
        }
        self.init(entity: tempEntity, insertInto: CoreDataManager.shared.viewContext)
        
        
        self.distance = distance
        self.duration = duration
        self.timestamp = Date()
        
        print("add new \(Route.type): \(self.timestamp)")
    }

    
}
