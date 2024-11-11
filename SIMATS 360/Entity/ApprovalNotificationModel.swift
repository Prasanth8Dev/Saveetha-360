//
//  ApprovalNotificationModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 28/10/24.
//

import Foundation

// MARK: - ApprovalNotificationModel
struct ApprovalNotificationModel: Codable {
    let status: Bool
    let message: String
    let notificationData: [RequestData]
}

// MARK: - NotificationDatum
struct RequestData: Codable {
    let id: Int
    let campus: String
    let bioID: Int
    let employeeName, phone, designation, leaveCategory: String
    let startDate, reason: String
    let profileImg: String
    let leaveType: String
    
    enum CodingKeys: String, CodingKey {
        case id, campus
        case bioID = "bio_id"
        case employeeName = "employee_name"
        case phone, designation, leaveCategory
        case startDate = "start_date"
        case reason, profileImg, leaveType
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
