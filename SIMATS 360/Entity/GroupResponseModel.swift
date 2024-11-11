//
//  GroupResponseModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 11/11/24.
//


import Foundation

// MARK: - GroupResponseModel
struct GroupResponseModel: Codable {
    let status: Bool
    let message: String
    let data: GroupData
}

// MARK: - DataClass
struct GroupData: Codable {
    let groupID, departmentID: Int
    let departmentName, groupName: String
    let employeeOptions: [EmployeeOption]

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case departmentID = "departmentId"
        case departmentName, groupName, employeeOptions
    }
}

// MARK: - EmployeeOption
struct EmployeeOption: Codable {
    let name: String
    let bioID: Int

    enum CodingKeys: String, CodingKey {
        case name
        case bioID = "bioId"
    }
}
