//
//  Utils.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation
import UIKit

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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: isoDate) else {
            return nil // Return nil if the conversion fails
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
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
    
    static func getCurrentYearWithMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"  // "MMMM" gives the full month name
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    
    static func getCurrentMonthWithDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    
    static func convertDateToMonthDay(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        dateFormatter.dateFormat = "MMMM dd"
        
        return dateFormatter.string(from: date)
    }
    static func attributedStringWithColorAndFont(
        text: String,
        colorHex: String,
        font: UIFont,
        length: Int,
        fontWeight: UIFont.Weight = .regular,
        fontSize: CGFloat = 16,
        secondColorHex: String = "#848884" // New color for the text after the range
    ) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: length)
        
        // First part: Apply the first color and font
        let primaryFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: colorHex),
            .font: primaryFont
        ]
        attributedString.addAttributes(primaryAttributes, range: range)
        
        // Second part: Apply a different color for the remaining text
        if text.count > length {
            let remainingRange = NSRange(location: length, length: text.count - length)
            let secondAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hex: secondColorHex),
                .font: primaryFont // Optionally, you can change the font here if needed
            ]
            attributedString.addAttributes(secondAttributes, range: remainingRange)
        }
        
        return attributedString
    }
    
    static  func removeAfterAnyString(from input: String, inputStr: String) -> String {
        if let range = input.range(of: inputStr) {
            let trimmedString = input[..<range.lowerBound].trimmingCharacters(in: .whitespaces)
            return String(trimmedString)
        }
        return input.trimmingCharacters(in: .whitespaces) 
    }
    
}

