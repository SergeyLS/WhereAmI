//
//  DateManager.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/6/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation


class DateManager {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
     static let dateNil = Date(timeIntervalSince1970: 0)
    
    
    static func dateToString(date: Date) -> String {
        
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
    
    
    static func dateAndTimeToString(date: Date) -> String {
        
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
    
    
}
