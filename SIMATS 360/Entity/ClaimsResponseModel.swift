//
//  ClaimsResponseModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 29/10/24.
//


import Foundation

// MARK: - ClaimsResponseModel
struct ClaimsResponseModel: Codable {
    let status: Bool
    let message: String
    let isClaimed: Bool
}
