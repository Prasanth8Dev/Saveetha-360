//
//  GeneralDutyModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 23/11/24.
//


import Foundation

// MARK: - GeneralDutyModel
struct GeneralDutyModel: Codable {
    let status: Bool
    let message: String
    let generalDuties: [GeneralDuty]
}

// MARK: - GeneralDuty
struct GeneralDuty: Codable {
    let id, groupID: Int
    let campus, department, shiftDate, shiftName: String
    let bioID, employeeName, createdAt, updatedAt: String
    let dutyExchanged: String
    let exchangeFrom, exchangeTo: Int
    let status: String
    let shiftID: Int
    let startTime, endTime: String
    let totalHrs: Int
    let dutySwipe, swipeDetails: String

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case campus, department
        case shiftDate = "shift_date"
        case shiftName = "shift_name"
        case bioID = "bio_id"
        case employeeName = "employee_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dutyExchanged = "duty_exchanged"
        case exchangeFrom = "exchange_from"
        case exchangeTo = "exchange_to"
        case status
        case shiftID = "shift_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case totalHrs = "total_hrs"
        case dutySwipe = "duty_swipe"
        case swipeDetails
    }
}
