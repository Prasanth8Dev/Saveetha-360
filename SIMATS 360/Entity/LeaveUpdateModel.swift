//
//  LeaveUpdateModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//


import Foundation

// MARK: - LeaveUpdateModel
struct LeaveUpdateModel: Codable {
    let status: Bool
    let message: String
    let data: LeaveStatusData
}

// MARK: - DataClass
struct LeaveStatusData: Codable {
    let leaveID: String

    enum CodingKeys: String, CodingKey {
        case leaveID = "leaveId"
    }
}
