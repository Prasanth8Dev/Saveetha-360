//
//  BufferTimeModel.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//



import Foundation

// MARK: - BufferTimeModel
struct BufferTimeModel: Codable {
    let status: Bool
    let message: String
    var data: [BufferTimeData]
}

// MARK: - Datum
struct BufferTimeData: Codable {
    let adjustedBuffTime: Double
    let gsonData: [GsonDatum]
}

// MARK: - GsonDatum
struct GsonDatum: Codable {
    let date: String
    let remainingBuff, exceed: Double
    let early: Int
    let status: Status
}

enum Status: String, Codable {
    case absent = "absent"
    case present = "present"
    case weekOff = "week off"
}
