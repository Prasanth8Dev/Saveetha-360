//
//  LeaveDetailModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 22/10/24.
//


import Foundation

// MARK: - LeaveDetailModel
struct LeaveDetailModel: Codable {
    let status: Bool
    let message: String
    let data: [LeaveDatas]
}

// MARK: - Datum
struct LeaveDatas: Codable {
    let leaveType, startDate, endDate, category: String
    let status: String
}
