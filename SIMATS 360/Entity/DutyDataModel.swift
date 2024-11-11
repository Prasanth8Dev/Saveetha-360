//
//  DutyDataModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//


import Foundation
// MARK: - DutyDataModel
struct DutyDataModel: Codable {
    let status: Bool
    let message: String
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let dutyID: Int
    let startdate, shift, totalHours, dutySwipe: String
    let swipeDetails, dutyStatus: String

    enum CodingKeys: String, CodingKey {
        case dutyID = "dutyId"
        case startdate, shift
        case totalHours = "total_hours"
        case dutySwipe = "duty_swipe"
        case swipeDetails = "swipe_details"
        case dutyStatus = "duty_status"
    }
}

