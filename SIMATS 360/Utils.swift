//
//  Utils.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation

class Utils {
    static func convertDateFormat(inputDate: String) -> String? {
            // Create a DateFormatter to parse the input
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM"
            
            // Convert the input string to a Date object
            if let date = inputFormatter.date(from: inputDate) {
                // Create another DateFormatter to format the Date object
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMM-yyyy"
                
                // Convert the Date object to the desired output string
                return outputFormatter.string(from: date)
            } else {
                return nil // Return nil if the input format is invalid
            }
        }
    
    static func formatDateString(_ isoDate: String) -> String? {
        let dateFormatter = DateFormatter()
        
        // Set the date format for the input string
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Convert the ISO string to a Date object
        guard let date = dateFormatter.date(from: isoDate) else {
            return nil // Return nil if the conversion fails
        }
        
        // Set the desired output format
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        // Convert the Date object back to the desired string format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func convertStringToInt(_ stringValue: String?) -> Int {
        guard let stringValue = stringValue, !stringValue.isEmpty else {
            return 0
        }
        
        return Int(stringValue) ?? 0
    }
    
    static func getCurrentDateInYearMonthFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM"  // Set the date format to YYYY:MM
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)  // Return the formatted date string
    }
    
    
    static func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"  // "MMMM" gives the full month name
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
}

