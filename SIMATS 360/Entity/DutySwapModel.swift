//
//  DutySwapModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 11/11/24.
//


import Foundation

// MARK: - DutySwapModel
struct DutySwapModel: Codable {
    let status: Bool
    let message: String
    let data: SwapResponse
}

// MARK: - DataClass
struct SwapResponse: Codable {
    let id: String
}
