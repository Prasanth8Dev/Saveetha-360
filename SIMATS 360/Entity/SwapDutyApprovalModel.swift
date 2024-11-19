//
//  SwapDutyApprovalModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 19/11/24.
//


import Foundation

// MARK: - SwapDutyApprovalModel
struct SwapDutyApprovalModel: Codable {
    let status: Bool
    let message: String
    let data: RequestStatusData
}

// MARK: - DataClass
struct RequestStatusData: Codable {
    let swapID: String

    enum CodingKeys: String, CodingKey {
        case swapID = "swapId"
    }
}
