//
//  SalaryReportModel.swift
//  Saveetha 360
//
//  Created by Prasanth S on 14/10/24.
//


import Foundation

// MARK: - SalaryReportModel
struct SalaryReportModel: Codable {
    let status: Bool
    let message: String
    let salaryReportData: [SalaryReportData]
}

// MARK: - SalaryReportDatum
struct SalaryReportData: Codable {
    let id: Int
    let period, campus: String
    let bioID: Int
    let employeeName, category, department: String
    let grossSalaryWithDeduction, lossOfPay, payableSalary: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case id, period, campus
        case bioID = "bio_id"
        case employeeName = "employee_name"
        case category, department
        case grossSalaryWithDeduction = "gross_salary_with_deduction"
        case lossOfPay = "loss_of_pay"
        case payableSalary = "payable_salary"
        case status
    }
}
