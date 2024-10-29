//
//  ClaimsDataModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 29/10/24.
//


import Foundation

// MARK: - ClaimsDataModel
struct ClaimsDataModel: Codable {
    let status: Bool
    let message: String
    let claimsData: [ClaimsDatum]
}

// MARK: - ClaimsDatum
struct ClaimsDatum: Codable {
    let startdate: String
}
