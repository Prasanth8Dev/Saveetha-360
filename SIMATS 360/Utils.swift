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
    }

