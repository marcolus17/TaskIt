//
//  Date.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/12/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import Foundation

class Date {
    // Helper function to create a new NSDate
    class func from(#year: Int, month: Int, day: Int) -> NSDate {
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        var gregorianCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let date = gregorianCalendar?.dateFromComponents(components)
        // dateFromComponents returns an optional so we must unwrap it before returning
        return date!
    }
    
    // Helper function to format an NSDate into a String for displaying
    class func toString(#date: NSDate) -> String {
        // Will display like this: M/dd/yy
        let dateString = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        return dateString
    }
}