//
//  NotificationModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 25/10/24.
//

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let status: Bool
    let message: String
    let notificationData: [NotificationData]
}

// MARK: - NotificationDatum
struct NotificationData: Codable {
    let notificationID: Int
    let notificationTitle, notificationMessage, notificationCategory: String
    let notificationSenderID, notificationReceiverID: Int
    let notificationCreatedAt: String

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case notificationTitle = "notification_title"
        case notificationMessage = "notification_message"
        case notificationCategory = "notification_category"
        case notificationSenderID = "notification_sender_id"
        case notificationReceiverID = "notification_receiver_id"
        case notificationCreatedAt = "notification_created_at"
    }
}
