//
//  SwapDutyStatusModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 15/11/24.
//

import Foundation

// Root response model
struct SwapDutyResponse: Codable {
    let status: Bool
    let message: String
    let swapDutyData: [SwapDuty]
}

// Swap duty details model
struct SwapDuty: Codable {
    let swapId: Int
    let empName: String
    let shift: String
    let swipesData: [SwipeDay]
    let contact: String
    let dutyStatus: String
    let date: String
    let exchangeStatus: String
}

// Swipe day details model
struct SwipeDay: Codable {
    let day: String
    let swipes: [SwipeData]
}

// Swipe details model
struct SwipeData: Codable {
    let swipeTime: String
    
    // CodingKey to map "SwipeTime" from JSON to "swipeTime" in Swift
    private enum CodingKeys: String, CodingKey {
        case swipeTime = "SwipeTime"
    }
}
