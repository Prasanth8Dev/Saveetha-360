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
    let category, leaveType: String
    let halfDaySession: String?
    let startDate: String
    let endDate: String?
    let totalDays: Double
    let assignedHeadID: Int
    let reason, file, status: String
    let sNo: Int
    let employeeName, employeeGrade, empType, password: String
    let staffID: String
    let registrationNum: JSONNull?
    let phone, address, email, designation: String
    let designationID: Int
    let department: String
    let departmentID: Int
    let role: String
    let roleID: Int
    let directorStatus: String
    let blockID: Int
    let doj, gender, dob, profileImg: String
    let leaveCateogry: String?

    enum CodingKeys: String, CodingKey {
        case id, campus
        case bioID = "bio_id"
        case category
        case leaveType = "leave_type"
        case halfDaySession = "half_day_session"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case assignedHeadID = "assigned_head_id"
        case reason, file, status
        case sNo = "s_no"
        case employeeName = "employee_name"
        case employeeGrade = "employee_grade"
        case empType = "emp_type"
        case password
        case staffID = "staff_id"
        case registrationNum = "registration_num"
        case phone, address, email, designation
        case designationID = "designation_id"
        case department
        case departmentID = "department_id"
        case role
        case roleID = "role_id"
        case directorStatus = "director_status"
        case blockID = "block_id"
        case doj, gender, dob, profileImg
        case leaveCateogry
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
