//
//  DutyRosterModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//


import Foundation

// MARK: - DutyRosterModel
struct DutyRosterModel: Codable {
    let status: Bool
    let message: String
    let data: [DutyData]
}

// MARK: - Datum
struct DutyData: Codable {
    let dutyID, empID: Int
    let empName: String
    let profileImg: JSONNull?
    let shift: Shift
    let swipeData: [SwipeDatum]
    let contact: String
    let designation: Designation
    let department, group: Department
    let date: String

    enum CodingKeys: String, CodingKey {
        case dutyID = "dutyId"
        case empID = "empId"
        case empName, profileImg, shift, swipeData, contact, designation, department, group, date
    }
}

enum Department: String, Codable {
    case anaesthesia = "Anaesthesia"
    case icu = "ICU"
}

enum Designation: String, Codable {
    case assistantProfessor = "Assistant Professor"
    case seniorResident = "Senior Resident"
}

enum Shift: String, Codable {
    case the24HoursDuty = "24 hours duty"
}

// MARK: - SwipeDatum
struct SwipeDatum: Codable {
    let day: Day
    let swipes: [Swipe]
}

enum Day: String, Codable {
    case day1 = "Day 1"
    case day2 = "Day 2"
}

// MARK: - Swipe
struct Swipe: Codable {
    let swipeTime: SwipeTime

    enum CodingKeys: String, CodingKey {
        case swipeTime = "Swipe Time"
    }
}

enum SwipeTime: String, Codable {
    case the0800 = "08:00"
    case the1500 = "15:00"
    case the2300 = "23:00"
}
