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
    let casualLeave: Int
    let sickLeave: Double
    let earnedLeave, academicLeave: Int
}
