//
//  AvailableLeaveModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation


// MARK: - AvailableLeaveModel
struct AvailableLeaveModel: Codable {
    let status: Bool
    let message: String
    let data: [LeaveData]
}

// MARK: - Datum
struct LeaveData: Codable {
    let casualLeave: Double
    let sickLeave: Double
    let earnedLeave, academicLeave, vacationLeave, restrictedLeave: Double
}
