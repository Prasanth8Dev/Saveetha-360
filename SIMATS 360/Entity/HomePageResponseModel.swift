//
//  HomePageResponse.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation

// MARK: - HomePageResponse
struct HomePageResponse: Codable {
    let status: Bool
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let attendance: [Attendance]
    let summary: [Summary]
}

// MARK: - Attendance
struct Attendance: Codable {
    let date, duration, presence: String
    let exceed, early, remainingBufferTime: Int
    let holidayCredits: String

    enum CodingKeys: String, CodingKey {
        case date, duration, presence, exceed, early
        case remainingBufferTime = "remaining_buffer_time"
        case holidayCredits = "holiday_credits"
    }
}

// MARK: - Summary
struct Summary: Codable {
    let totalWorkingDays: Int
    let totalPresent: Double
    let presentDays, totalHalfWorkingDays, absentDays, weekoffDays: Int
    let totalWorkingHours: Double
    let adjustedBuffTime: Int
    let attendancePercentage: Double
    let lop: Int
}
