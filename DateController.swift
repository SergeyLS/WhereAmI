//
//  DateController.swift
//  OnlineTrainer
//
//  Created by Sergey Leskov on 11/16/16.
//  Copyright © 2016 Sergey Leskov. All rights reserved.
//

import Foundation


class DateController {
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    static let shared = DateController()
    static let dateNil = Date(timeIntervalSince1970: 0)

    
    func dateToString(date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        //dateFormatter.dateFormat = "MM-dd-yyyy"
//       
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        
//        
//        return dateFormatter.string(from: date)
        
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }

    
    func dateTimeToString(date: Date) -> String {
        //        let dateFormatter = DateFormatter()
        //        //dateFormatter.dateFormat = "MM-dd-yyyy"
        //
        //        dateFormatter.dateStyle = DateFormatter.Style.medium
        //
        //
        //        return dateFormatter.string(from: date)
        
        return DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
    

}
