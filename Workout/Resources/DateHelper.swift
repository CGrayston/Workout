//
//  DateHelper.swift
//  Workout
//
//  Created by Chris Grayston on 4/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//
import Foundation

class DateHelper {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //        formatter.weekdaySymbols = DateFormatter.init().shortWeekdaySymbols
        //        formatter.dateStyle = .long
        //        formatter.timeStyle = .short
        
        let format = "EEEE-dd-MMM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    //    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
    //
    //        let currentCalendar = Calendar.current
    //
    //        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
    //        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
    //
    //        return end - start
    //    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
