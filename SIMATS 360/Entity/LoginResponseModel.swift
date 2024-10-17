//
//  LoginResponseModel.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//

import Foundation


// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let userData: [UserData]
}

// MARK: - UserDatum
struct UserData: Codable {
    let campus, category: String
    let bioID: Int

    enum CodingKeys: String, CodingKey {
        case campus, category
        case bioID = "bioId"
    }
}
