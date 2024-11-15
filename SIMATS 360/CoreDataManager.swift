//
//  CoreDataManager.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 04/11/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    func saveGeneralNotifyInDB(_ notificationData: NotificationData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<GeneralNotification> = GeneralNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notificationId == %d", notificationData.notificationID)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // Only add new notification if no existing entry is found
            if results.isEmpty {
                if let entity = NSEntityDescription.entity(forEntityName: "GeneralNotification", in: managedContext) {
                    let details = GeneralNotification(entity: entity, insertInto: managedContext)
                    details.notificationId = Int64(notificationData.notificationID)
                    details.notificationTitle = notificationData.notificationTitle
                    details.notificationMessage = notificationData.notificationMessage
                    details.notificationCategory = notificationData.notificationCategory
                    details.notificationSenderId = Int64(notificationData.notificationSenderID)
                    details.notificationReceiverId = Int64(notificationData.notificationReceiverID)
                    details.isOpened = false
                }
                
                appDelegate.saveContext()
            } else {
                print("Notification with ID \(notificationData.notificationID) already exists.")
            }
        } catch {
            print("Failed to fetch notifications: \(error.localizedDescription)")
        }
    }
    func saveApproveNotifyInDB(_ notificationData: RequestData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ApproveNotification> = ApproveNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notificationId == %d", notificationData.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // Only add new notification if no existing entry is found
            if results.isEmpty {
                if let entity = NSEntityDescription.entity(forEntityName: "ApproveNotification", in: managedContext) {
                    let details = ApproveNotification(entity: entity, insertInto: managedContext)
                    //let details = GeneralNotification(entity: entity, insertInto: managedContext)
                    details.notificationId = String(notificationData.id)
                    details.leaveCategory = notificationData.leaveCategory
                    details.bioId = String(notificationData.bioID)
                    details.campus = notificationData.campus
                    details.employeeName = String(notificationData.employeeName)
                    details.phone = (notificationData.phone)
                    details.designation = notificationData.designation
                    details.startDate = notificationData.startDate
                    details.reason = notificationData.reason
                    details.leaveType = notificationData.leaveType
                    details.isOpened = false
                    details.profileImg = notificationData.profileImg
                }
                
                appDelegate.saveContext()
            } else {
                print("Notification with ID \(notificationData.id) already exists.")
            }
        } catch {
            print("Failed to fetch notifications: \(error.localizedDescription)")
        }
    }
    
    func updateApproveNotifyInDB(_ notificationData: RequestData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ApproveNotification> = ApproveNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notificationId == %d", notificationData.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let existingNotification = results.first, !existingNotification.isOpened {
                existingNotification.notificationId = String(notificationData.id)
                existingNotification.leaveCategory = notificationData.leaveCategory
                existingNotification.bioId = String(notificationData.bioID)
                existingNotification.campus = notificationData.campus
                existingNotification.employeeName = String(notificationData.employeeName)
                existingNotification.phone = (notificationData.phone)
                existingNotification.designation = notificationData.designation
                existingNotification.startDate = notificationData.startDate
                existingNotification.reason = notificationData.reason
                existingNotification.leaveType = notificationData.leaveType
                existingNotification.isOpened = true
                existingNotification.profileImg = notificationData.profileImg
                
                appDelegate.saveContext()
            }
        } catch {
            print("Failed to fetch or update notification: \(error.localizedDescription)")
        }
    }
    
    func updateGeneralNotifyInDB(_ notificationData: NotificationData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GeneralNotification> = GeneralNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notificationId == %d", notificationData.notificationID)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let existingNotification = results.first, !existingNotification.isOpened {
                existingNotification.isOpened = true
                existingNotification.notificationTitle = notificationData.notificationTitle
                existingNotification.notificationMessage = notificationData.notificationMessage
                existingNotification.notificationCategory = notificationData.notificationCategory
                existingNotification.notificationSenderId = Int64(notificationData.notificationSenderID)
                existingNotification.notificationReceiverId = Int64(notificationData.notificationReceiverID)
                
                appDelegate.saveContext()
            }
        } catch {
            print("Failed to fetch or update notification: \(error.localizedDescription)")
        }
    }

    
    private func checkIsAlreadyExist(notificationId: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GeneralNotification> = GeneralNotification.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notificationId == %d", notificationId)
        do {
            let data = try managedContext.fetch(fetchRequest)
            if data.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func fetchAllGeneralNotification() -> [NotificationData] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GeneralNotification> = GeneralNotification.fetchRequest()
        do {
            let notificationData = try managedContext.fetch(fetchRequest)
            
            // Map Core Data entities to NotificationData objects
            let notifications = notificationData.map { entity in
                NotificationData(notificationID: Int(entity.notificationId), notificationTitle: entity.notificationTitle ?? "", notificationMessage: entity.notificationMessage ?? "", notificationCategory: entity.notificationCategory ?? "", notificationSenderID: Int(entity.notificationSenderId), notificationReceiverID: Int(entity.notificationReceiverId), notificationCreatedAt: entity.notificationCreatedAt ?? "",isOpened: entity.isOpened)
            }
            
            return notifications
        } catch {
            print("Error fetching all users from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAllApproveNotification() -> [RequestData] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ApproveNotification> = ApproveNotification.fetchRequest()
        do {
            let notificationData = try managedContext.fetch(fetchRequest)
            
            // Map Core Data entities to NotificationData objects
            let notifications = notificationData.compactMap { entity -> RequestData? in
                // Assuming notificationId and bioId should be Int
                guard
                    let notificationId = Int(entity.notificationId ?? ""),
                    let bioId = Int(entity.bioId ?? "")
                else {
                    return nil // Skip this item if required properties are missing
                }

                // Use default values or cast to the required types here
                return RequestData(
                    id: notificationId,
                    campus: entity.campus ?? "",
                    bioID: bioId,
                    employeeName: entity.employeeName ?? "",
                    phone: entity.phone ?? "",
                    designation: entity.designation ?? "",
                    leaveCategory: entity.leaveCategory ?? "",
                    startDate: entity.startDate ?? "",
                    reason: entity.reason ?? "",
                    profileImg: entity.profileImg ?? "",
                    leaveType: entity.leaveType ?? "",isOpened: entity.isOpened
                )
            }

            
            return notifications
        } catch {
            print("Error fetching all users from Core Data: \(error.localizedDescription)")
            return []
        }
    }
}
