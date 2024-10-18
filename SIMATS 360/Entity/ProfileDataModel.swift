//
//  ProfileDataModel.swift
//  Saveetha 360
//
//  Created by Prasanth S on 17/10/24.
//

import Foundation

// MARK: - ProfileDataModel
struct ProfileDataModel: Codable {
    let status: Int
    let message: String
    let data: [ProfileUserData]
    let internalExp: Int
    let externalExp: String

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case internalExp = "internalExp"
        case externalExp = "externalExp"
    }
}

// MARK: - UserData
struct ProfileUserData: Codable {
    let campus, employeeName, category, dob: String
    let doj, phone, email, address: String
    let profileImg: String
    let bioID: Int
    let staffID: String
    let designationID: Int
    let designationName: String

    enum CodingKeys: String, CodingKey {
        case campus
        case employeeName = "employee_name"
        case category, dob, doj, phone, email, address, profileImg
        case bioID = "bio_id"
        case staffID = "staff_id"
        case designationID = "designation_id"
        case designationName = "designation_name"
    }
}
