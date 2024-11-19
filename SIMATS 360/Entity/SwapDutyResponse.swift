//
//  SwapDutyResponse.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 19/11/24.
//


import Foundation

// Root model
struct SwapDutyDataResponse: Codable {
    let status: Bool
    let message: String
    let swapDutyNotificationData: [SwapDutyNotification]
}

// SwapDutyNotification model
struct SwapDutyNotification: Codable {
    let swapId: Int
    let empName: String
    let shift: String
    let swipesData: [SwipesData]
    let contact: String
    let dutyStatus: String
    let date: String
}

// SwipesData model
struct SwipesData: Codable {
    let day: String
    let swipes: [SwipeTimes]
}

// Swipe model
struct SwipeTimes: Codable {
    let swipeTime: String
}
