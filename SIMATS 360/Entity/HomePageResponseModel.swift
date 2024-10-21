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
    let data: [HomeData]
}

// MARK: - HomeData
struct HomeData: Codable {
    let totalPresent, presentDays, absentDays, totalHalfWorkingDays: Int
    let weekoffDays: Int
    let totalWorkingHours, adjustedBuffTime: Double  // Should be Double, not Int
    let attendancePercentage: Int
    let totalWorkingDays: Int// Should be Int, not Double
}

