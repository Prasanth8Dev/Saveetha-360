//
//  ProfileDataModel.swift
//  Saveetha 360
//
//  Created by Prasanth S on 17/10/24.
//


// MARK: - ProfileDataModel
import Foundation

// MARK: - ProfileDataModel
struct ProfileDataModel: Codable {
    let status: Int
    let message: String
    let data: ProfileData?
}

// MARK: - DataClass
struct ProfileData: Codable {
    let internalExperience, externalExperience, campus, employeeName: String
    let category, dob, doj, phone: String
    let email, address: String
    let profileImageURL: String
    let bioID: Int
    let staffID: String
    let designationID: Int
    let designationName: String

    enum CodingKeys: String, CodingKey {
        case internalExperience = "internal_experience"
        case externalExperience = "external_experience"
        case campus
        case employeeName = "employee_name"
        case category, dob, doj, phone, email, address, profileImageURL
        case bioID = "bio_id"
        case staffID = "staff_id"
        case designationID = "designation_id"
        case designationName = "designation_name"
    }
}


// MARK: - ExperienceType Enum to Handle Cleaned String, Int, or Nil
enum ExperienceType: Codable {
    case string(String)
    case int(Int)
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .none
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .none:
            try container.encodeNil()
        }
    }

    // Helper method to clean and return the value as String
    func cleanedValue() -> String {
        switch self {
        case .string(let value):
            // Check if it's wrapped like String("...") and clean it
            if value.hasPrefix("String("), let range = value.range(of: "(") {
                let cleanedString = String(value.dropFirst(7).dropLast(1))
                return cleanedString
            }
            return value
        case .int(let value):
            return "\(value)" // Convert Int to String
        case .none:
            return "N/A"
        }
    }
}
