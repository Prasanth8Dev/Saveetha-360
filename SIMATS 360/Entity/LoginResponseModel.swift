//
//  LoginResponseModel.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Bool?
    let message: String?
    let userData: [UserData]?
}

// MARK: - UserData
struct UserData: Codable {
    let campus: String?
    let category: String?
    let bioID: Int?
    let profileImgURL: String?
    let userName: String?
    let headID: Int?
    let role: String?

    enum CodingKeys: String, CodingKey {
        case campus, category
        case bioID = "bioId"
        case profileImgURL = "profileImgUrl"
        case userName
        case headID = "headId"
        case role
    }
}
