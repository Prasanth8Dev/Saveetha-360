//
//  SalaryReportResponse.swift
//  Saveetha 360
//
//  Created by Prasanth S on 18/10/24.
//

import Foundation
// MARK: - SalaryReportResponse
struct SalaryReportResponse: Codable {
    let status: Bool
    let message: String
    let salaryReportData: [SalaryReport]
}

// MARK: - SalaryReportData
struct SalaryReport: Codable {
    let id: Int
    let campus: String
    let bioID: Int
    let category, empType: String
    let earningsBasicSalary: Int
    let earningsDA: Int
    let earningsHRA: Int
    let earningsCCA: Int
    let earningsOthers: Int
    let deductionsDeductions: Int
    let earningsTA: Int?
    let deductionsPF: Int?
    let deductionsESI: String?
    let earningsPA: Int?

    enum CodingKeys: String, CodingKey {
        case id, campus
        case bioID = "bio_id"
        case category
        case empType = "emp_type"
        case earningsBasicSalary = "earnings_basic_salary"
        case earningsDA = "earnings_da"
        case earningsHRA = "earnings_hra"
        case earningsCCA = "earnings_cca"
        case earningsOthers = "earnings_others"
        case deductionsDeductions = "deductions_deductions"
        case earningsTA = "earnings_ta"
        case deductionsPF = "deductions_pf"
        case deductionsESI = "deductions_esi"
        case earningsPA = "earnings_pa"
    }

    // Custom initializer to handle conversion from String to Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode values as String first, then convert to Int, handle nulls or empty strings
        id = try container.decode(Int.self, forKey: .id)
        campus = try container.decode(String.self, forKey: .campus)
        bioID = try container.decode(Int.self, forKey: .bioID)
        category = try container.decode(String.self, forKey: .category)
        empType = try container.decode(String.self, forKey: .empType)
        
        earningsBasicSalary = Int(try container.decodeIfPresent(String.self, forKey: .earningsBasicSalary) ?? "") ?? 0
        earningsDA = Int(try container.decodeIfPresent(String.self, forKey: .earningsDA) ?? "") ?? 0
        earningsHRA = Int(try container.decodeIfPresent(String.self, forKey: .earningsHRA) ?? "") ?? 0
        earningsCCA = Int(try container.decodeIfPresent(String.self, forKey: .earningsCCA) ?? "") ?? 0
        earningsOthers = Int(try container.decodeIfPresent(String.self, forKey: .earningsOthers) ?? "") ?? 0
        deductionsDeductions = Int(try container.decodeIfPresent(String.self, forKey: .deductionsDeductions) ?? "") ?? 0
        
        // Handle optional Int values for other fields (earnings_ta, deductions_pf, earnings_pa)
        earningsTA = Int(try container.decodeIfPresent(String.self, forKey: .earningsTA) ?? "")
        deductionsPF = Int(try container.decodeIfPresent(String.self, forKey: .deductionsPF) ?? "")
        deductionsESI = try container.decodeIfPresent(String.self, forKey: .deductionsESI)
        earningsPA = Int(try container.decodeIfPresent(String.self, forKey: .earningsPA) ?? "")
    }
}

