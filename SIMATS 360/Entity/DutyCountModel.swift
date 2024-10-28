//
//  DutyCountModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//


import Foundation

// MARK: - DutyCountModel
struct DutyCountModel: Codable {
    let status: Bool
    let message: String
    let pendingCount: Int
}
